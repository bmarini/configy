require 'test_helper'

class NestedConfigTest < MiniTest::Unit::TestCase
  def setup
    Configy.load_path    = scratch_dir
    Configy.cache_config = nil
  end

  def test_nested_configs_should_be_accessible_as_methods
    with_config_file({
      'common' => {
        'level1' => {
          'level2' => {
            'level3' => 'whynot'
          }
        }
      }
    }, 'nested_config') do
      Configy.create('nested_config')
      assert_equal 'whynot', NestedConfig.level1.level2.level3
    end
  end
end