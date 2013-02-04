require "ruby_xymon/version"
require 'socket'

module RubyXymon

  def self.send(msg, this_host=nil, this_port=nil)
    host = this_host.nil? ? self.config[:host] : this_host
    port = this_port.nil? ? self.config[:port] : this_port

    # create
    t = self.new_socket(host, port)

    # write
    t.puts(msg)

    # close
    t.close
  end


  def self.config=(hash_or_yml_file={})

    case hash_or_yml_file
      when Hash
        @_xymon_config = hash_or_yml_file
      when String
        @_xymon_config = YAML.load_file(hash_or_yml_file)
      else
        raise "config takes either a Hash type object or an IO type object that contains YAML"
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


end