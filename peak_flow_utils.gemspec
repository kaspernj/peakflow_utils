$:.push File.expand_path("lib", __dir__)

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

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "3.7.2"
end
