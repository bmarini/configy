Gem::Specification.new do |s|
  s.name     = "configy"
  s.version  = "1.1.0"

  s.authors  = [ "Gabe Varela", "Ben Marini", "Chip Miller" ]
  s.date     = "2012-03-18"
  s.email    = "bmarini@gmail.com"
  s.summary  = "Simple yaml driven configuration gem"
  s.homepage = "http://github.com/bmarini/configy"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.required_rubygems_version = ">= 1.3.6"
  s.add_runtime_dependency "hashie", "~> 1.2.0"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "minitest"

  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
end

