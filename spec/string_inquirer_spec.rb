require 'spec_helper'

describe Configy::StringInquirer do

  before do
    @subject = Configy::StringInquirer.new "foo"
  end

  it "should inherit from String" do
    @subject.is_a?( String ).must_equal true
  end

  it "should == 'foo'" do
    @subject.must_equal 'foo'
  end

  it "should be foo?" do
    @subject.foo?.must_equal true
  end

  it "should not be bar?" do
    @subject.bar?.must_equal false
  end

  it "should raise NoMethodError if not predicate" do
    assert_raises NoMethodError do
      @subject.foo
    end
  end
end
