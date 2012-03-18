# Configy

## Description

It allows to have a file (`config/app_config.yml`) with application configuration parameters.
It should have a "common" section with all parameters along with default values and can also
contain a section for each of the rails environments (development, test, production, or 
your custom one). The values from the current environment section will override the values in the 
"common" section.

If some developer needs his own specific values for his working copy, he can simply create 
a `config/app_config.local.yml` file and override any value there, again having a "common" section 
and a section for each environment. 

Nothing is mandatory (files, sections) you just have what you really need. The files are parsed with ERB,
so they can contain some Ruby. It also checks for file modifications so you don't have to restart the server to pick up new values on production.

## Usage

Configy provides an [optional] generator.

    rails g configy:install

An example of a config file (app_config.yml):

``` yaml
common:
  admin_email: admin@domain.com
  xml_rpc_url: http://domain.com:8000/
  media_path: <%= RAILS_ROOT %>/tmp/media

development:
  xml_rpc_url: http://localhost:8000/

test:
  xml_rpc_url: http://localhost:8008/
```
  
In an initializer:

``` ruby
Configy.create(:app_config)
```

Then, in the application you can use the config parameters like this:

``` ruby
AppConfig.xml_rpc_url
```

So it means that you've got a Config object which holds all the configuration parameters defined. 
It doesn't allow to change the values in the application code, BTW.

## Authors

* Gabe Varela
* Ben Marini
* Chip Miller

## History

The Configy gem based on the AppConfig plugin which was evolved from the original plugin by Eugene Bolshakov, eugene.bolshakov@gmail.com, http://www.taknado.com

The plugin is based on the idea described here:
http://kpumuk.info/ruby-on-rails/flexible-application-configuration-in-ruby-on-rails/lang-pref/en/