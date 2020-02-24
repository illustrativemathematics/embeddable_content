module EmbeddableContent
  class EmbeddedTagInfo
    attr_reader :record, :embedded_model, :attr, :dom_node

    def initialize(record, embedded_model, attr, dom_node)
      @record         = record
      @embedded_model = embedded_model
      @attr           = attr
      @dom_node       = dom_node
    end

    def available?
      match.present?
    end

    def embedded_record_id
      match.try :first
    end

    def embedded_record_ext
      match.try :last
    end

    def embedded_record
      @embedded_record ||= embedded_model.find embedded_record_id
    end

    private

    def src
      @src ||= dom_node.attributes['src'].to_html
    end

    def embed_src_path
      embedded_model.model_name.route_key
    end

    def match
      @match ||= src.match(%r{\/#{embed_src_path}\/(\d+)\.(\w+)}).try :captures
    end

    def document
      @document ||= Nokogiri::HTML.fragment searchable_text
    end

    def searchable_text
      record[attr].is_a?(Array) ? record[attr].join(' ') : record[attr]
    end
  end
end
