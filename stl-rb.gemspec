require_relative "lib/stl/version"

Gem::Specification.new do |spec|
  spec.name          = "stl-rb"
  spec.version       = Stl::VERSION
  spec.summary       = "Seasonal-trend decomposition for Ruby"
  spec.homepage      = "https://github.com/ankane/stl-ruby"
  spec.license       = "Unlicense OR MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{ext,lib}/**/*"]
  spec.require_path  = "lib"
  spec.extensions    = ["ext/stl/extconf.rb"]

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "rice", ">= 4.3.3"
end
