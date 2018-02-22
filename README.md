RubyXymon [![Build Status](https://travis-ci.org/rubyisbeautiful/ruby_xymon.png)](https://travis-ci.org/rubyisbeautiful/ruby_xymon)
========

A simple gem for Xymon

Thanks to Greg Faust, [Scott Sayles](https://github.com/codemariner)

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_xymon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_xymon

## Usage

In its current state, the gem is simple to use.  You can set two configuration variables, host and port, like this:

    RubyXymon.config[:host] = 'localhost'
    RubyXymon.config[:port] = '1984'

The values in the example are the defaults.
You can also set the configuration at once, using either a Hash or a String, which points to a file:

    RubyXymon.config = { :host => 'localhost' }
    RubyXymon.config = "/some/dir/xymon.yml"

You can send a raw Xymon message using the send_formatted_message method:

    RubyXymon.send_formatted_message("status www.http green #{Time.zone.now} Web OK")

Now you can send a simple status message above, using params:

    RubyXymon.create_formatted_status_message('www', 'http', 'green', additional_text: 'Web OK')

For more information on Xymon, see the [Xymon man page](http://xymon.sourceforge.net/xymon/help/manpages/man1/xymon.1.html)

The API of sending (and in the near future, reading) messages from Xymon is not defined yet, but it will definitely change.  

##

Future improvements:
* methods based on other Xymon messages.  Each message would have its own syntax,
  e.g. RubyXymon.enable(hostname, testname)
* methods to read from Xymon, e.g. "query" message
* update config method to allow multiple configs / multiple servers
* timeouts
* swallow errors vs raise error methods (send_formatted_message! vs send_formatted_message)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
