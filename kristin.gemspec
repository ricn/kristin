# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kristin/version'

Gem::Specification.new do |spec|
  spec.name          = "kristin"
  spec.version       = Kristin::VERSION
  spec.authors       = ["Richard Nyström"]
  spec.email         = ["ricny046@gmail.com"]
  spec.description   = %q{ Convert PDF docs to beautiful HTML files without losing text or format. This gem uses pdf2htmlEX to do the conversion.}
  spec.summary       = %q{ Convert PDF docs to beautiful HTML files without losing text or format. This gem uses pdf2htmlEX to do the conversion. }
  spec.homepage      = "https://github.com/ricn/kristin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "spoon"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
