require 'spec_helper'

describe "Configy.section" do
  before do
    Configy.section = nil
  end

  it "should default to development" do
    Configy.section.must_equal "development"
  end

  it "should detect configy environment" do
    with_env( "CONFIGY_ENV", "staging" ) do
      Configy.section.must_equal "staging"
    end
  end

  it "should detect rails environment" do
    with_env( "RAILS_ENV", "test" ) do
      Configy.section.must_equal "test"
    end
  end

  it "should detect rack environment" do
    with_env( "RACK_ENV", "production" ) do
      Configy.section.must_equal "production"
    end
  end

  it "should be able to override" do
    Configy.section = "custom"
    Configy.section.must_equal "custom"
  end

  describe "string inquiry" do
    before do
      Configy.section = nil
      Configy.section.must_equal "development"
    end

    it "should be development?" do
      Configy.section.development?.must_equal true
    end

    it "should not be staging?" do
      Configy.section.staging?.must_equal false
    end
  end
end
