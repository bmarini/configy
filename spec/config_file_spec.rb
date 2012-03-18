require 'spec_helper'

describe Configy::ConfigFile do

  it "test should load a config from a file" do
    with_config_file( { 'common' => {'a' => '1', 'b' => '2' } }, 'app_config' ) do |file, hash|
      configfile = Configy::ConfigFile.new(file, 'development')
      configfile.load_file.must_equal hash
    end
  end

  it "test should create an instance of config store" do
    with_config_file( { 'common' => {'a' => '1', 'b' => '2' } }, 'app_config' ) do |file, hash|
      configfile = Configy::ConfigFile.new(file, 'development')
      configfile.config.must_be_instance_of Configy::ConfigStore
    end
  end

  it "test should be aware of a files mtime" do
    configfile = Configy::ConfigFile.new('nonexistent/file', 'development')
    configfile.mtime.must_equal Time.at(0)

    with_config_file( { 'common' => {'a' => '1', 'b' => '2' } }, 'app_config' ) do |file, hash|
      configfile = Configy::ConfigFile.new(file, 'development')
      configfile.mtime.must_equal File.mtime(file)
    end
  end

end
