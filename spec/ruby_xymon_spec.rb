require 'spec_helper'

describe "RubyXymon" do

  before :each do
    RubyXymon.instance_variable_set('@_xymon_config', nil)
  end


  describe 'default_config' do

    it "should have a port of 1984" do
      RubyXymon.default_config[:port].should == '1984'
    end

    it "should have a host of localhost" do
      RubyXymon.default_config[:host].should == 'localhost'
    end

  end


  describe 'new_socket' do

    it "should return a TCPSocket" do
      TCPSocket.should_receive(:new).with('localhost', '1984')

      RubyXymon.new_socket('localhost', '1984')
    end

  end


  describe 'config' do

    it "should set @_xymon_config if it was nil" do
      RubyXymon.instance_variable_get("@_xymon_config").nil?.should be_true

      RubyXymon.config

      RubyXymon.instance_variable_get("@_xymon_config").nil?.should be_false
    end

    it "should return @_xymon_config if it was not nil" do
      RubyXymon.instance_variable_set("@_xymon_config", 'foo')

      RubyXymon.config.should == 'foo'
    end

  end


  describe 'config=' do

    it 'should accept a hash and set it' do
      RubyXymon.config = { :foo => 'bar' }

      RubyXymon.config.should == { :foo => 'bar' }
    end


    it 'should accept a YAML file and set it' do
      YAML.should_receive(:load_file).with('some_file').and_return('foo')

      RubyXymon.config = 'some_file'

      RubyXymon.config.should == 'foo'
    end

  end


  describe 'send' do

    it 'should use default host if not passed' do
      RubyXymon.should_receive(:new_socket).with('localhost', '1984').and_return(double.as_null_object)

      RubyXymon.send('foo')
    end


    it 'should use default port if not passed' do
      RubyXymon.should_receive(:new_socket).with('baconhost', '1984').and_return(double.as_null_object)

      RubyXymon.send('foo', 'baconhost')
    end


    it "the socket should receive the message" do
      duck = double.as_null_object
      duck.should_receive(:puts).with('foo')

      RubyXymon.stub(:new_socket).and_return(duck)

      RubyXymon.send('foo')
    end

  end


end