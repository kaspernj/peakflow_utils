$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "peak_flow_utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "peak_flow_utils"
  s.version     = PeakFlowUtils::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["kaspernj@gmail.com"]
  s.homepage    = "https://github.com/kaspernj/peak_flow_utils"
  s.summary     = "Utilities to be used with PeakFlow."
  s.description = "Utilities to be used with PeakFlow."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"

  s.add_runtime_dependency "active-record-transactioner", ">= 0.0.7"
  s.add_runtime_dependency "service_pattern", ">= 0.0.3"

  s.add_development_dependency "pry-rails", "0.3.6"
  s.add_development_dependency "redis", "3.3.5"
  s.add_development_dependency "rspec-rails", "3.7.2"
  s.add_development_dependency "sidekiq", "5.1.1"
  s.add_development_dependency "sqlite3", "1.3.13"
end
