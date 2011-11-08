# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fiat/version"

Gem::Specification.new do |s|
  s.name        = "fiat"
  s.version     = Fiat::VERSION
  s.authors     = ["Harry Schwartz"]
  s.email       = ["hrs@cs.wm.edu"]
  s.homepage    = "https://github.com/hrs/fiat"
  s.summary     = %q{The "auto-Make-er."}
  s.description = %q{Like autotest for Makefiles: fiat automatically and repeatedly executes a given make task every time one of the task's dependencies is saved.}

  s.rubyforge_project = "fiat"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = ["fiat"]
  s.require_paths = ["lib"]

  s.add_dependency "colorize"
end
