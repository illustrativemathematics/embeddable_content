require Rails.root.join 'lib/tasks/support/verbosity.rb'

module EmbeddableContent
  class EmbedderBase
    include HtmlService::Helpers
    include Verbosity

    attr_reader :config, :options

    delegate :tex_output_format, :render_images?, :scope, :xml?,
             :output_format, :fragment?, :remove_repaired_math_spans?,
             :replacement_map, :all_other_targets, :aria_attrs?,
             to: :config

    def self.default_s3_bucket
      ENV['AWS_S3_BUCKET']
    end

    def initialize(config, options = {})
      @config  = config
      @options = options
      show_options if show_options?
    end

    def target
      @target ||= config.target.to_sym
    end

    def to_s
      "#{self.class} for #{config.inspect}"
    end

    def s3_bucket
      @s3_bucket ||= options[:s3_bucket] ||
                     self.class.default_s3_bucket
    end

    private

    def module_name
      @module_name ||= self.class.name.deconstantize
    end

    def embedding_module
      @embedding_module ||= module_name.demodulize
    end

    def route_keys
      @route_keys ||= [embedding_module.underscore]
    end
  end
end
