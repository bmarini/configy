require 'spec_helper'

describe Configy::ConfigStore do

  it "test should initialize with a hash" do
    hash   = {'common' => {'a' => 1, 'b' => 2} }
    config = Configy::ConfigStore.new(hash)
    config.to_hash.must_equal hash
  end

  it "test_should_compile_a_selected_section_with_the_common_section" do
    hash1 = {
      'common'      => { 'a' => "A",  'b' => "B" },
      'development' => { 'a' => "A*", 'c' => "C" }
    }

    config = Configy::ConfigStore.new(hash1).compile('development')

    config['a'].must_equal "A*"
    config['b'].must_equal "B"
    config['c'].must_equal "C"
  end

  it "test should merge two configs together" do
    hash1 = {
      'common'      => { 'a' => "A",  'b' => "B", 'c' => "C" },
      'development' => { 'a' => "A*", 'c' => "C*", 'd' => "D", 'e' => "E" }
    }

    hash2 = {
      'common'      => { 'c' => "C**", 'f' => "F" },
      'development' => { 'e' => "E*" }
    }

    config1 = Configy::ConfigStore.new(hash1).compile('development')
    config2 = Configy::ConfigStore.new(hash2).compile('development')
    config  = config1.merge(config2)

    config['a'].must_equal "A*"
    config['b'].must_equal "B"
    config['c'].must_equal "C**"
    config['d'].must_equal "D"
    config['e'].must_equal "E*"
    config['f'].must_equal "F"
  end

  it "test should raise an exception if config is missing" do
    assert_raises Configy::ConfigParamNotFound do
      Configy::ConfigStore.new({})['oops']
    end
  end

end
