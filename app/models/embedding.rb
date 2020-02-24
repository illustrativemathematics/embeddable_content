class Embedding < ApplicationRecord
  INDIFFERENT_RUN_ORDER      = 0
  MATH_TYPESETTING_RUN_ORDER = 1000
  DEFAULT_RUN_ORDER          = INDIFFERENT_RUN_ORDER

  RUN_ORDER_ENUM_CONSULT_BEFORE_CHANGING = {
    indifferent:      INDIFFERENT_RUN_ORDER,
    math_typesetting: MATH_TYPESETTING_RUN_ORDER
  }.freeze

  enum run_order: RUN_ORDER_ENUM_CONSULT_BEFORE_CHANGING

  def self.in_run_order
    order :run_order
  end

  def doc_processor_for(embedder)
    "EmbeddableContent::#{processor_module}::DocProcessor"
      .constantize.new embedder
  end

  def process_target?(target)
    processor_targets.include? target.to_s
  end
end
