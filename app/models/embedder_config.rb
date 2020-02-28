class EmbedderConfig < ApplicationRecord
  TARGET_CATEGORY_ENUM_CONSULT_BEFORE_CHANGING =
    { cms:      0,
      print:    1,
      web:      2,
      editable: 3,
      exported: 4,
      qti:      5,
      cc:       6 }.freeze
  SCOPE_CATEGORY_ENUM_CONSULT_BEFORE_CHANGING =
    { document: 0,
      fragment: 1 }.freeze
  TEX_OUTPUT_FORMAT_CONSULT_BEFORE_CHANGING =
    { mathjax: 0,
      svg:     1,
      mml:     2,
      canvas:  3 }.freeze
  OUTPUT_FORMAT_CONSULT_BEFORE_CHANGING =
    { html: 0,
      xml:  1 }.freeze
  DEFAULT_OUTPUT_FORMAT = OUTPUT_FORMAT_CONSULT_BEFORE_CHANGING[:html]

  ALL_TARGETS = TARGET_CATEGORY_ENUM_CONSULT_BEFORE_CHANGING.keys.freeze

  enum target:            TARGET_CATEGORY_ENUM_CONSULT_BEFORE_CHANGING
  enum scope:             SCOPE_CATEGORY_ENUM_CONSULT_BEFORE_CHANGING
  enum tex_output_format: TEX_OUTPUT_FORMAT_CONSULT_BEFORE_CHANGING
  enum output_format:     OUTPUT_FORMAT_CONSULT_BEFORE_CHANGING

  def self.for_target(target)
    find_by target: target
  end

  def all_other_targets
    @all_other_targets ||= ALL_TARGETS - [target.to_sym]
  end

  # EDC: this could be added to field on table
  def aria_attrs?
    !qti?
  end
end
