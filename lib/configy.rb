module Configy
  autoload :Base, 'configy/base'
  autoload :ConfigFile, 'configy/config_file'
  autoload :ConfigStore, 'configy/config_store'
  autoload :StringInquirer, 'configy/string_inquirer'

  class ConfigyError < StandardError; end
  class ConfigParamNotFound < ConfigyError; end

  class << self
    attr_writer :load_path, :cache_config

    def load_path
      if @load_path
        @load_path
      elsif defined? Rails
        Rails.root.join("config")
      elsif ENV['RAILS_ROOT']
        "#{ENV['RAILS_ROOT']}/config"
      elsif ENV['RACK_ROOT']
        "#{ENV['RACK_ROOT']}/config"
      else
        'config'
      end
    end

    def section
      @section ||= Configy::StringInquirer.new(section_string)
    end

    def section=( value )
      @section = value.is_a?(String) ? Configy::StringInquirer.new(value) : value
    end

    def cache_config
      @cache_config = false if @cache_config.nil?
      @cache_config
    end

    protected

    def section_string
      ENV["CONFIGY_ENV"] || ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development"
    end
  end

  def self.camelize(phrase)
    camelized = phrase.gsub(/^[a-z]|\s+[a-z]|_+[a-z]|-+[a-z]/i) { |a| a.upcase }
    camelized.gsub!(/\s/, '')
    camelized.gsub!(/_/, '')
    camelized.gsub!(/-/, '')
    return camelized
  end

  # The main interface for creating Configy instances
  def self.create(file, parent=Object)
    parent.const_set( camelize(file.to_s), Configy::Base.new(file, section, load_path, cache_config) )
  end
end
