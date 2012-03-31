# Configy

Configy creates a config object based on a YAML file.

## Summary

It allows you to have a file (`config/app_config.yml`) with application
configuration parameters. It should have a "common" section with all
parameters along with default values and can also contain a section for each
application environment (development, test, production, or your custom one).
The values from the current environment section will override the values in
the "common" section.

If a developer needs his own specific values for his working copy, he can
simply create a `config/app_config.local.yml` file and override any value
there, again having a "common" section and a section for each environment.

The files are parsed with ERB. Configy also checks for file modifications so
you don't have to restart the server to pick up new values on production.

## Example

config/app_config.yaml:

``` yaml
common:
  appname: "My App"
  caching:
    enabled: false
  facebook:
    appid: 123
    secret: abc

production:
  caching:
    enabled: true
    default_max_age: <%= 1.hour %>
  facebook:
    appid: 456
    secret: def

```

Assuming ENV['RACK_ENV'] == "production"

``` ruby
Configy.create("app_config")      # Creates AppConfig constant
AppConfig.caching.enabled?        # => true
AppConfig.caching.default_max_age # => 3600
AppConfig.appname                 # => "My App"
AppConfig.facebook.appid          # => 456

# Or with less magic:

config = Configy::Base.new("app_config", "production", Rails.root.join("config") )
config.caching.enabled? # => true
config['caching']['enabled'] # => true
...

```

## Features

### Sections

Configy assumes that you are breaking your configurations into sections. It
will automatically detect which section to use. It looks for an environment
variable in following order

`ENV['CONFIGY_ENV'], ENV['RAILS_ENV'], ENV['RACK_ENV']`

and assumes you have a section in your YAML file named the same way, for
example:

``` yaml
development:
  facebook_app_id: 123456
  facebook_secret: abcdef
production:
  facebook_app_id: 456789
  facebook_secret: defghi
```

If none of the environment variables above are set, it defaults to `development`.

### Common section

If you have a section named `common`, that section will provide default values
for all other sections. Under the hood, Configy deep merges the environment
section into the common section. For example:

``` yaml
common:
  newrelic_enabled: true
  newrelic_key: "123456"

development:
  newrelic_enabled: false

staging:

production:

```

All environments will inherit the `common` section configurations, and the
`development` environment overrides the `newrelic_enabled` setting.

### Nested configs

You can nest configs as much as you like.

``` yaml
common:
  facebook:
    app:
      id: 123
```

``` ruby
AppConfig.facebook.app.id # => 123
```

### Local config file

If you have a config file named `config/app_config.yml` and another config
file named `config/app_config.local.yml`, the local config file's configurations
will override the main config file's configurations.

### ERB

Config files are parsed as ERB templates

### Auto reloading

Configy will check the config file's mtime to see if it needs to
reload it's configuration. You can disable this with `Configy.cache_config = true`

### Rails generator

Configy provides an [optional] generator.

    rails g configy:install

## Authors

* Gabe Varela
* Ben Marini
* Chip Miller
* Bram Swenson
* Jeremy Ruppel

## History

The Configy gem based on the AppConfig plugin which was evolved from the original plugin by Eugene Bolshakov, eugene.bolshakov@gmail.com, http://www.taknado.com

The plugin is based on the idea described here:
http://kpumuk.info/ruby-on-rails/flexible-application-configuration-in-ruby-on-rails/lang-pref/en/