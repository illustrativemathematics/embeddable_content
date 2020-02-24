module EmbeddableContent
  class VisualElementNodeProcessor < RecordNodeProcessor
    include TemplateBased

    delegate :attribution, :description, :long_description, :title, :caption,
             to: :record

    MISSING_LABEL_TEXT = ''.freeze
    def label_text
      caption.presence || MISSING_LABEL_TEXT
    end
  end
end
