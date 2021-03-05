require File.expand_path('../lib/omniauth-vkontakte/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Anton Maminov"]
  gem.email         = ["anton.linux@gmail.com"]
  gem.description   = %q{Unofficial VKontakte strategy for OmniAuth 1.0}
  gem.summary       = %q{Unofficial VKontakte strategy for OmniAuth 1.0}
  gem.homepage      = "https://github.com/mamantoha/omniauth-vkontakte"

  gem.files         = Dir['lib/**/*.rb'] + Dir['bin/*'] # `git ls-files`.split("\n")
  gem.files += Dir['[A-Z]*'] + Dir['test/**/*']
  gem.files.reject! { |fn| fn.include? "CVS" }
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) } # `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/}) # `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-vkontakte"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Vkontakte::VERSION

  gem.add_dependency 'omniauth-oauth2', '~> 1.2'
end
