$spec = Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = 'relaunch'
  s.version = '0.16.0'
  s.required_ruby_version = '>= 3.3'

  s.description = "Restarts your app when a file changes. A no-frills, command-line alternative to Guard, Shotgun, Autotest, etc."
  s.summary     = "Launches an app, and restarts it whenever the filesystem changes. A no-frills, command-line alternative to Guard, Shotgun, Autotest, etc."

  s.authors = ["Alex Chaffee", "Patrik Ragnarsson"]
  s.email = ["alexch@gmail.com", "patrik@starkast.net"]

  s.files = %w[
    README.md
    Changelog.md
    Fork.md
    LICENSE
    Rakefile
    relaunch.gemspec
    bin/rerun
    bin/rerun.bat
    bin/relaunch
    bin/relaunch.bat
    icons/rails_grn_sml.png
    icons/rails_red_sml.png] +
      Dir['lib/**/*.rb']
  s.executables = ['rerun', 'relaunch']
  s.test_files = s.files.select {|path| path =~ /^spec\/.*_spec.rb/}

  s.extra_rdoc_files = %w[README.md]

  s.add_runtime_dependency 'listen', '~> 3.0'

  s.homepage = "https://github.com/spinels/relaunch"
  s.metadata["homepage_uri"] = s.homepage
  s.metadata["changelog_uri"] = "#{s.homepage}/blob/main/Changelog.md"
  s.metadata["source_code_uri"] = "#{s.homepage}/tree/main"
  s.metadata["rubygems_mfa_required"] = "true"
  s.require_paths = %w[lib]

  s.license = 'MIT'
end
