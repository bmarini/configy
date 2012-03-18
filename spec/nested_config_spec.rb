require 'spec_helper'

describe Configy do
  describe "with nested configurations" do
    before do
      Configy.load_path    = scratch_dir
      Configy.cache_config = nil
    end

    it "should be accessbile as methods" do
      with_config_file({
        'common' => {
          'level1' => {
            'level2' => {
              'level3' => 'whynot',
              'falsekey' => false,
              'truekey' => true
            }
          }
        }
      }, 'nested_config') do
        Configy.create('nested_config')
        NestedConfig.level1.level2.level3.must_equal "whynot"
        NestedConfig.level1.level2.nokey?.must_equal false
        NestedConfig.level1.level2.falsekey?.must_equal false
        NestedConfig.level1.level2.truekey?.must_equal true
      end
    end
  end
end