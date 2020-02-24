module EmbeddableContent
  class RecordNodeProcessor < NodeProcessor
    delegate :title, to: :record

    def record_id
      @record_id ||= tag_match_data[:id] if tag_references_record?
    end

    def record_model
      @record_model ||= tag_match_data[:model].classify.constantize if
        tag_references_record?
    end

    def record_css_id_for(type)
      "#{type}-#{record_model}-#{record_id}"
    end

    def record
      @record ||= target_scope.find record_id
    end

    def s3_url(with_extension: false)
      with_extension ? s3_url_with_extension : bare_s3_url
    end

    def cms_url
      src_url
    end

    def storage_url
      blob.service_url content_type: content_type
    end

    def attached_file
      record.file
    end

    def node_selector_class
      "embedded-content-#{record_model.model_name.param_key.dasherize}"
    end

    private

    delegate :s3_bucket,    to: :embedder
    delegate :blob,         to: :attached_file
    delegate :content_type, to: :blob

    def bare_s3_url
      "https://s3.amazonaws.com/#{s3_bucket}/#{blob_key}"
    end

    def s3_url_with_extension
      "#{bare_s3_url}.#{blob.filename.extension}"
    end

    def blob_key
      blob.key
    end

    def src_url
      @src_url ||= node.attr 'src'
    end

    def tag_match_data
      @tag_match_data ||= regex_src_url.match src_url
    end

    def regex_src_url
      %r{\/(?<model>#{route_keys.join('|')})\/(?<id>\d+)\.(?<ext>\w+)}
    end

    def target_scope
      record_model
    end

    def tag_references_record?
      tag_match_data.present?
    end

    def node_should_be_replaced?
      super && tag_match_data.present?
    end
  end
end
