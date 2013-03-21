require "ruby_xymon/version"
require 'socket'

# @note see http://www.xymon.com/xymon/help/manpages/man1/xymon.1.html for the complete Xymon man page
#       that was used to build this
# @todo internationalize colors
module RubyXymon

  class InvalidArgumentError < StandardError; end

  VALID_COLORS = %w( green yellow red clear client )

  # @param [String] hostname the host
  # @param [String] testname the name of the test (or column)
  # @param [String] color one of green, yellow, red, clear, or client
  # @param [Hash] options the options to create the message
  # @option options [String] :lifetime in seconds, defaults to 30 minutes
  #   allowing seconds allows this to be used with ActiveSupport (among other similar libs)
  #   to do things like { lifetime: 2.hours }
  # @option options [String] :group optional
  # @option options [String] :base_text any optional text, defaults to Timestamp
  # @option options [String] :additional_text any optional text to be placed after base_text, defaults to blank
  # @example RubyXymon.create('banks', 'cash', 'green', lifetime: 10*60, additional_text: 'OK')
  #         will create the message:
  #         "status+10 banks.cash green 2013-03-21 12:00:00 OK"
  # @raise InvalidArgumentError
  def self.create_formatted_status_message(hostname, testname, color, options={})
    if testname =~ /\./
      raise InvalidArgumentError.new "Xymon does not allow '.' in the test name"
    end

    if !VALID_COLORS.include?(color)
      raise InvalidArgumentError.new "Xymon only allows green, yellow, red, clear, or client for color"
    end

    options[:base_text] ||= Time.now.utc.to_s

    if options.has_key? :lifetime
      options[:lifetime] = RubyXymon.format_time_in_seconds(options[:lifetime])
    end
    options[:lifetime] ||= '30'

    text = options[:base_text]
    text << (" " + options[:additional_text]) if options.has_key?(:additional_text)

    if options[:group]
      "status+#{options[:lifetime]}/#{options[:group]} #{hostname}.#{testname} #{color} #{text}"
    else
      "status+#{options[:lifetime]} #{hostname}.#{testname} #{color} #{text}"
    end
  end


  # sends what is presumed to be a properly formatted message to the Xymon host and port
  # really does nothing magical...just opens TCP socket, sends message, closes socket
  # @param [String] msg the properly formatted message string
  # @param [String] this_host the host name or IP.  Will consult config if not provided
  # @param [String,Fixnum] this_port the port.  Will consult config if not provided
  # @see RubyXymon#config
  def self.send_formatted_message(msg, this_host=nil, this_port=nil)
    host = this_host.nil? ? self.config[:host] : this_host
    port = this_port.nil? ? self.config[:port] : this_port

    # create
    t = self.new_socket(host, port)

    # write
    t.puts(msg)

    # close
    t.close
  end


  # Loads config from a hash, or a YAML file
  def self.config=(hash_or_yml_file={})

    case hash_or_yml_file
      when Hash
        @_xymon_config = default_config.merge(hash_or_yml_file)
      when String
        @_xymon_config = default_config.merge(YAML.load_file(hash_or_yml_file))
      else
        raise ArgumentError.new("config takes either a Hash type object or a filename pointing to a YAML")
    end

  end


  def self.config
    if @_xymon_config.nil?
      @_xymon_config = default_config
    end
    @_xymon_config
  end


  def self.new_socket(host, port)
    TCPSocket.new(host, port)
  end


  def self.default_config
    {
      :host => 'localhost',
      :port => '1984'
    }
  end


  # takes a time in seconds and turns it into a Xymon duration string
  # it floors, since Xymon just supports Integer + character time formats
  # like 5h, so format_time_in_seconds(7100) will be 1 hour
  # Xymon allows minutes (default), hours, days or weeks
  # @param [Fixnum] t time in seconds
  # @return [String] xymon formatted time
  def self.format_time_in_seconds(t)
    case
      when t < 60
        '1'
      when t < 3600 # something less than 1 hour
        (t/60).to_s
      when t < 86400 # something less than 1 day
        (t/60/60).to_s + 'h'
      when t < 604800 # something less than 7 days
        (t/60/60/24).to_s + 'd'
      when t >= 604800 # something more than 7 days
        (t/60/60/24/7).to_s + 'w'
      else
        raise "t should be a number representing an interval in seconds"
    end
  end



end
