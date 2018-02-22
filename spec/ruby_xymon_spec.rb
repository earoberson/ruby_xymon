require 'spec_helper'

describe 'RubyXymon' do

  before :each do
    RubyXymon.instance_variable_set('@_xymon_config', nil)
  end

  before :all do
    t = Time.utc(2013, 01, 01, 12, 0, 0)
    Timecop.freeze(t)
  end

  after :all do
    Timecop.return
  end

  describe 'default_config' do

    it 'should have a port of 1984' do
      expect(RubyXymon.default_config[:port]).to eq '1984'
    end

    it 'should have a host of localhost' do
      expect(RubyXymon.default_config[:host]).to eq 'localhost'
    end

  end


  describe 'new_socket' do

    it 'should return a TCPSocket' do
      expect(TCPSocket).to receive(:new).with('localhost', '1984')

      RubyXymon.new_socket('localhost', '1984')
    end

  end


  describe 'config' do

    it 'should set @_xymon_config if it was nil' do
      expect(RubyXymon.instance_variable_get("@_xymon_config").nil?).to be_truthy

      RubyXymon.config

      expect(RubyXymon.instance_variable_get("@_xymon_config").nil?).to be_falsey
    end

    it 'should return @_xymon_config if it was not nil' do
      RubyXymon.instance_variable_set("@_xymon_config", 'foo')

      expect(RubyXymon.config).to eq 'foo'
    end

  end


  describe 'config=' do

    it 'should accept a hash and merge it to defaults' do
      RubyXymon.config = { host: 'foo' }

      expect(RubyXymon.config).to eq({ host: 'foo', port: '1984' })
    end


    it 'should accept a YAML file and merge it to defaults' do
      expect(YAML).to receive(:load_file).with('some_file').and_return({ host: 'foo' })

      RubyXymon.config = 'some_file'

      expect(RubyXymon.config).to eq({ host: 'foo', port: '1984' })
    end

  end


  describe 'send_formatted_message' do

    it 'should use default host if not passed' do
      expect(RubyXymon).to receive(:new_socket).with('localhost', '1984').and_return(double.as_null_object)

      RubyXymon.send_formatted_message('foo')
    end


    it 'should use default port if not passed' do
      expect(RubyXymon).to receive(:new_socket).with('baconhost', '1984').and_return(double.as_null_object)

      RubyXymon.send_formatted_message('foo', 'baconhost')
    end


    it 'the socket should receive the message' do
      duck = double.as_null_object
      duck.is_expected.to receive(:puts).with('foo')

      allow(RubyXymon).to receive(:new_socket).and_return(duck)

      RubyXymon.send_formatted_message('foo')
    end

  end


  describe 'create_formatted_status_message' do


    # sanity check
    it 'should not raise if all params are valid' do
      expect { RubyXymon.create_formatted_status_message('foo', 'bar', 'green') }.to_not raise_error
    end

    it 'should raise if the color is not valid' do
      expect { RubyXymon.create_formatted_status_message('foo', 'bar', 'teal') }.to raise_error RubyXymon::InvalidArgumentError
    end

    it 'should raise if the test name contains a dot' do
      expect { RubyXymon.create_formatted_status_message('foo', 'b.r', 'green') }.to raise_error RubyXymon::InvalidArgumentError
    end

    it 'should set the base text as the current time if not passed' do
      expect(RubyXymon.create_formatted_status_message('foo', 'bar', 'green')).to match /2013-01-01 12:00:00 UTC/
    end

    it 'should use base text if passed' do
      expect(RubyXymon.create_formatted_status_message('foo', 'bar', 'green', base_text: 'chunky')).to match /chunky/
    end

    it 'should add additional text if passed' do
      expect(RubyXymon.create_formatted_status_message('foo', 'bar', 'green', additional_text: 'bacon')).to match /bacon/
    end

    it 'should have 30 as default lifetime' do
      expect(RubyXymon.create_formatted_status_message('foo', 'bar', 'green')).to match /^status\+30/
    end

    it 'should include group is passed' do
      expect(RubyXymon.create_formatted_status_message('foo', 'bar', 'green', group: 'pager')).to match /\/pager/
    end

  end


  describe 'format_time_in_seconds' do

    it 'should return 1 for 10 seconds' do
      expect(RubyXymon.format_time_in_seconds(10)).to eq '1'
    end


    it 'should return 1 for 60 seconds' do
      expect(RubyXymon.format_time_in_seconds(60)).to eq '1'
    end


    it 'should return 5 for 350 seconds' do
      expect(RubyXymon.format_time_in_seconds(350)).to eq '5'
    end


    it 'should return 1h for 3600 seconds' do
      expect(RubyXymon.format_time_in_seconds(3600)).to eq '1h'
    end


    it 'should return 1d for 86400 seconds' do
      expect(RubyXymon.format_time_in_seconds(86400)).to eq '1d'
    end


    it 'should return 1w for 604800 seconds' do
      expect(RubyXymon.format_time_in_seconds(604800)).to eq '1w'
    end

  end


end
