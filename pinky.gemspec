# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pinky"
  s.version = "0.2.8"
  s.platform = "java"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joel Friedman"]
  s.date = "2013-03-24"
  s.description = "Cache your api objects in member easier, with associations."
  s.email = "asher.friedman@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/pinky.rb",
    "lib/pinky/associations.rb",
    "lib/pinky/cache.rb",
    "lib/pinky/energizer_bunny/connection.rb",
    "lib/pinky/energizer_bunny/subscription.rb",
    "lib/pinky/exceptions.rb",
    "lib/pinky/has_caches.rb",
    "lib/pinky/model.rb",
    "lib/pinky/model_fetch_methods.rb",
    "pinky.gemspec",
    "spec/pinky/associations_spec.rb",
    "spec/pinky/cache_spec.rb",
    "spec/pinky/has_caches_spec.rb",
    "spec/pinky/model_fetch_methods_spec.rb",
    "spec/pinky/model_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/trunkclub/pinky"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "in memory API caching made easy"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<uuid>, ["= 2.3.6"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<hot_bunnies>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.11.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<uuid>, ["= 2.3.6"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<hot_bunnies>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.11.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<uuid>, ["= 2.3.6"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<hot_bunnies>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.11.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

