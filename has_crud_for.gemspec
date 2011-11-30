# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "has_crud_for/version"

Gem::Specification.new do |s|
  s.name        = "has_crud_for"
  s.version     = HasCrudFor::VERSION
  s.authors     = ["Jan Dudek"]
  s.email       = ["jd@jandudek.com"]
  s.homepage    = ""
  s.summary     = %q{Law of Demeter in ActiveRecord models}
  s.description = %q{HasCrudFor is a small meta-programming snippet that adds find_*, build_*, create_*, update_* and destroy_* methods intended as a better API for your associations}

  s.rubyforge_project = "has_crud_for"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "i18n"
end
