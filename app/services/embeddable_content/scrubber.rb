module EmbeddableContent
  class Scrubber < EmbedderBase
    def scrub(document)
      document.search(scrubbed_nodes_selector).remove
      document
    end

    private

    def scrubbed_nodes_selector
      all_selectors.join ','
    end

    def all_selectors
      selectors_for_other_targets <<
        '.removed-for-all-embedder-targets' <<
        selector_for_current_target
    end

    def selector_for_current_target
      ".removed-for-#{target}-embedder-target"
    end

    def selectors_for_other_targets
      all_other_targets.map { |tgt| selector_for_other_target tgt }
    end

    def selector_for_other_target(tgt)
      ".removed-for-all-but-#{tgt}-embedder-target"
    end
  end
end
