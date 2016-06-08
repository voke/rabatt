# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rabatt/version'

Gem::Specification.new do |spec|
  spec.name          = "rabatt"
  spec.version       = Rabatt::VERSION
  spec.authors       = ["Gustav"]
  spec.email         = ["gustav@invoke.se"]

  spec.summary       = 'Rabatt allows you to access advertiser voucher codes'
  spec.description   = 'Rabatt allows you to access advertiser voucher codes'
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'ruby-hmac', '~> 0.4', '>= 0.4.0'
  spec.add_dependency 'saxerator', "~> 0.9.5"
  spec.add_dependency 'savon', '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "minitest-reporters"

end
