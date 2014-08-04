## 1.2.0 (2014-08-04)

* Loosen version requirement for hashie

## 1.1.3 (2012-03-31)

* Allow hash access from main config object
* Check environment variables instead of constants

## 1.1.2 (2012-03-30)

* If ENV['CONFIGY_ENV'] is set, use that to determine config section to use.

## 1.1.1 (2012-03-18)

* Allow Configy to define configs within other modules

## 1.1.0 (2012-03-18)

* Allow nested configs to be accessible as methods, via Hashie::Mash
  Example: AppConfig.aws.secret