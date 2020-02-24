module EmbeddableContent
  class EmbeddedTags
    attr_reader :record, :attr, :embedded_models

    def initialize(record, attr, embedded_models)
      @record          = record
      @attr            = attr
      @embedded_models = embedded_models
    end

    def each
      embedded_models.each do |model|
        document.css(model.embeddable_tag_name).each do |dom_node|
          info = EmbeddedTagInfo.new record, model, attr, dom_node
          yield info if info.available?
        end
      end
    end

    private

    def document
      @document ||= Nokogiri::HTML.fragment searchable_text
    end

    def searchable_text
      record[attr].is_a?(Array) ? record[attr].join(' ') : record[attr]
    end
  end
end
