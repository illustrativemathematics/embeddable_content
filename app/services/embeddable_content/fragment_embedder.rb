module EmbeddableContent
  class FragmentEmbedder < EmbedderBase
    attr_reader :fragment

    def initialize(fragment)
      super EmbedderConfig.for_target(:exported)
      @fragment = fragment
    end

    def run
      return '' if fragment.blank?

      embedder.embed_content!(fragment)
    end

    private

    def embedder
      @embedder ||= Embedder.new config
    end

    def opts
      @opts ||= { s3_bucket: s3_bucket }
    end

    def s3_bucket
      ENV.fetch('OCX_EXPORT_DEST_S3_BUCKET', 'cms-im')
    end
  end
end
