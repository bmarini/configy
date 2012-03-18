require 'spec_helper'
require 'erb'

describe Configy::Base do
  MAIN_CONFIG = <<-EOS
common:
  a: 1
  b: <%= 2 + 2 %>
  c: 2
special:
  b: 5
  d: 6
extra:
  f: 4
  a: 8
  EOS

  LOCAL_CONFIG = <<-EOS
common:
  a: '2'
special:
  b: 8
  e: <%= 6 * 7 %>
  EOS

  it "test top level configs should be accesssible as methods" do
    with_config_file(MAIN_CONFIG, 'config') do
      config = Configy::Base.new('config', 'special', scratch_dir)
      config.a.must_equal 1
    end
  end

  it "test method missing" do
    config = Configy::Base.new('config', 'special', scratch_dir)
    assert_raises NoMethodError do
      config.nope = "oops"
    end
  end

  it "test should override params with another file and use proper section" do
    with_config_file(MAIN_CONFIG, 'config') do
      with_config_file(LOCAL_CONFIG, 'config.local') do
        config = Configy::Base.new('config', 'special', scratch_dir)
        config.a.must_equal '2'
        config.b.must_equal 8
        config.c.must_equal 2
        config.d.must_equal 6
        config.e.must_equal 42
      end
    end
  end

  it "test should reload a config file if changed" do
    with_config_file({ 'common' => {'a' => 'foo'} }, 'config') do |file1, hash1|
      with_config_file({ 'special' => {'b' => 'bar'} }, 'config.local') do |file2, hash2|

        config = Configy::Base.new('config', 'special', scratch_dir)
        config.a.must_equal 'foo'
        config.b.must_equal 'bar'

        # Simulate 1 second going by
        config.send(:config).mtime -= 1

        File.open(file1, 'w') do |f|
          f.puts( {'common' => {'a' => 'foo*'} }.to_yaml )
        end

        config.a.must_equal 'foo*'

        # Simulate 1 second going by
        config.send(:config).mtime -= 1

        File.open(file2, 'w') do |f|
          f.puts( {'special' => {'b' => 'bar*'} }.to_yaml )
        end

        config.b.must_equal 'bar*'

      end
    end
  end

  it "test should not reload a config file if changed and cache config is true" do
    with_config_file({ 'common' => {'a' => 'foo'} }, 'config') do |file1, hash1|
      with_config_file({ 'special' => {'b' => 'bar'} }, 'config.local') do |file2, hash2|

        config = Configy::Base.new('config', 'special', scratch_dir, true)
        config.a.must_equal 'foo'
        config.b.must_equal 'bar'

        # Simulate 1 second going by
        config.send(:config).mtime -= 1

        File.open(file1, 'w') do |f|
          f.puts( {'common' => {'a' => 'foo*'} }.to_yaml )
        end

        config.a.must_equal 'foo'

        # Simulate 1 second going by
        config.send(:config).mtime -= 1

        File.open(file2, 'w') do |f|
          f.puts( {'special' => {'b' => 'bar*'} }.to_yaml )
        end

        config.b.must_equal 'bar'

      end
    end
  end
end
