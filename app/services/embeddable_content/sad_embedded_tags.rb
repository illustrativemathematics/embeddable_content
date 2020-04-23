module EmbeddableContent
  class SadEmbeddedTags
    attr_accessor :root_node, :sad_related_records, :embedded_models

    def initialize(root_node, embedded_models)
      @root_node = root_node
      @sad_related_records = SadRelatedRecords.new root_node
      @embedded_models     = embedded_models
    end

    def each
      @root_node.tags.each do |tag|
        tag.html_attrs.each do |attr|
          EmbeddedTags.new(tag, attr, embedded_models).each do |info|
            yield nil, nil, info
          end
        end
      end

      sad_related_records.each do |node, node_address, related_record|
        related_record.html_attrs.each do |attr|
          EmbeddedTags.new(related_record, attr, embedded_models).each do |info|
            yield node, node_address, info
          end
        end
      end
    end
  end
end
