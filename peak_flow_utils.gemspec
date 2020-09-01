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
  s.required_ruby_version = ">= 2.5"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.executables << "peak_flow_rspec_files"

  s.add_dependency "rails", ">= 5.0.0"

  s.add_runtime_dependency "active-record-transactioner"
  s.add_runtime_dependency "array_enumerator"
  s.add_runtime_dependency "service_pattern"

  s.add_development_dependency "redis"
  s.add_development_dependency "sidekiq"
  s.add_development_dependency "tzinfo-data"
end
