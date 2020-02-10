# frozen_string_literal: true

require "active_support/core_ext"
require "tax_calculator/receipt"
require "tax_calculator/receipt_item"

module TaxCalculator
  class Error < StandardError; end
end
