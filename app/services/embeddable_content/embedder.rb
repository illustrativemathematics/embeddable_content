module EmbeddableContent
  class Embedder < EmbedderBase
    NO_REPLACEMENTS_BY_DEFAULT = {}.freeze

    attr_reader :html, :document

    def initialize(target, options = {})
      super EmbedderConfig.for_target(target), options
    end

    def image_catalog
      @image_catalog ||= Set.new
    end

    def embed_content!(content)
      @html = content.to_str.dup
      @document = scrub parse_html
      perform_replacements
      run_doc_processors
      write_embedded_html_to_tmp_file if debug_embedder?
      @html
    end

    def rebuild_document
      @document = parse_html
    end

    private

    def parse_html
      case scope&.to_sym
      when :document then html_parser.parse    html
      when :fragment then html_parser.fragment html
      else raise "Unrecognized parsing scope: #{scope}"
      end
    end

    def run_doc_processors
      doc_processors.each(&:process!)
    end

    def html_parser
      @html_parser ||=
        case output_format&.to_sym
        when :html then Nokogiri::HTML
        when :xml  then Nokogiri::XML
        else raise "Unrecognized output format: #{output_format}"
        end
    end

    def scrub(document)
      Scrubber.new(config).scrub document
    end

    def perform_replacements
      replacements.each { |old, new| html.gsub! old, new }
    end

    def replacements
      token_replacement_map[target] || NO_REPLACEMENTS_BY_DEFAULT
    end

    def token_replacement_map
      @token_replacement_map ||=
        TokenReplacementMap.new(replacement_map).target_regexp_map
    end

    def doc_processors
      @doc_processors ||=
        embeddings.map { |embedding| embedding.doc_processor_for self }
    end

    def embeddings
      @embeddings ||= Embedding.all.in_run_order
    end

    def debug_embedder?
      ENV['DEBUG_EMBEDDER'] == 'true'
    end

    def write_embedded_html_to_tmp_file
      Rails.root.join('tmp').join(temp_filename).write html
    end

    def temp_filename
      Time.current.strftime "embedded-#{target}-%Y-%m-%d-%H%M.html"
    end
  end
end
