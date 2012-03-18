require 'spec_helper'

describe Configy do
  before do
    Configy.load_path    = scratch_dir
    Configy.cache_config = nil
  end

  it "should camelize" do
    Configy.camelize('config').must_equal 'Config'
    Configy.camelize('some_config').must_equal 'SomeConfig'
    Configy.camelize('some-other_config').must_equal 'SomeOtherConfig'
  end

  it "should create a configuration class based on a yaml file" do
    with_config_file( {'common' => {'a' => '1', 'b' => '2' }}, 'app_config' ) do |file, hash|
      Configy.create('app_config')
      Object.const_defined?(:AppConfig).must_equal true
      AppConfig.b.must_equal '2'
    end
  end

  it "test should create a configuration class based on a yaml file within a parent module" do
    with_config_file( {'common' => {'a' => '1', 'b' => '2' }}, 'app_config' ) do |file, hash|
      Object.const_set('MyApp', Module)
      Configy.create('app_config', MyApp)
      MyApp.const_defined?(:AppConfig).must_equal true
      MyApp::AppConfig.b.must_equal '2'
    end
  end

  it "test cache config always defaults to false" do
    Configy.section = 'production'
    Configy.cache_config.must_equal false

    Configy.section = 'development'
    Configy.cache_config.must_equal false
  end

  it "test should be able to manually set cache config" do
    Configy.cache_config = true
    Configy.create('dummy')

    Configy.cache_config.must_equal true
    Dummy.cache_config?.must_equal true
  end

end
