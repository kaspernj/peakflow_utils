$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "peak_flow_utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "peak_flow_utils"
  s.version     = PeakFlowUtils::VERSION
  s.authors     = ["kaspernj"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://github.com/kaspernj/peak_flow_utils"
  s.summary     = "Utilities to be used with PeakFlow."
  s.description = "Utilities to be used with PeakFlow."
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.4.0"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"

  s.add_dependency "active-record-transactioner"
  s.add_dependency "array_enumerator"
  s.add_dependency "bigdecimal"
  s.add_dependency "drb"
  s.add_dependency "mutex_m"
  s.add_dependency "service_pattern", ">= 1.0.5"

  s.metadata["rubygems_mfa_required"] = "true"
end
