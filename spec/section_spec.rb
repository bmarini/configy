require 'spec_helper'

describe "Configy.section" do
  before do
    Configy.section = nil
  end

  it "should default to development" do
    Configy.section.must_equal "development"
  end

  it "should detect configy environment" do
    with_const( :CONFIGY_ENV, "staging" ) do
      Configy.section.must_equal "staging"
    end
  end

  it "should detect rails 3 environment" do
    rails3_obj = MiniTest::Mock.new
    rails3_obj.expect :env, "staging"

    with_const(:Rails, rails3_obj) do
      Configy.section.must_equal "staging"
    end
  end

  it "should detect rails 2 environment" do
    with_const( :RAILS_ENV, "test" ) do
      Configy.section.must_equal "test"
    end
  end

  it "should detect rack environment" do
    with_const( :RACK_ENV, "production" ) do
      Configy.section.must_equal "production"
    end
  end

  it "should be able to override" do
    Configy.section = "custom"
    Configy.section.must_equal "custom"
  end
end
