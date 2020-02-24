lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'embeddable_content/version'

Gem::Specification.new do |spec|
  spec.name    = 'embeddable_content'
  spec.version = EmbeddableContent::VERSION
  spec.authors = ['Eric Connally']
  spec.email   = ['eric@illustrativemathematics.org']

  spec.summary =
    'Embeddable Content functionality extracted from cms-im app.'
  spec.description =
    'Provides embeddable content functionality to apps using this gem.'
  spec.homepage =
    'https://github.com/illustrativemathematics/embedded_content'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib db]

  spec.add_dependency 'activerecord'

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'parallel_tests'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0'
end
