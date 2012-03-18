require 'spec_helper'

describe "Configy.load_path" do
  before do
    Configy.load_path = nil
  end

  it "should default to config" do
    Configy.load_path.must_equal "config"
  end

  it "should detect rails 3 config dir" do
    rails3_obj = MiniTest::Mock.new
    rails3_obj.expect :root, Pathname.new("path/to/rails/root")

    with_const(:Rails, rails3_obj) do
      Configy.load_path.must_equal Rails.root.join("config")
    end
  end

  it "should detect rails 2 config dir" do
    with_const( :RAILS_ROOT, "path/to/rails/root" ) do
      Configy.load_path.must_equal "#{RAILS_ROOT}/config"
    end
  end

  it "should detect rack config dir" do
    with_const( :RACK_ROOT, "path/to/rack/root" ) do
      Configy.load_path.must_equal "#{RACK_ROOT}/config"
    end
  end
end