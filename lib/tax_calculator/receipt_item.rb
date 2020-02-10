# frozen_string_literal: true

module TaxCalculator
  class ReceiptItem
    EXEMPT_TAX_IDENTICATION = %w[book chocolate pills milk].freeze
    IMPORTED_PRODUCT_IDENTICATION = %w[imported].freeze
    BASE_TAX_RATE = 0.10
    IMPORT_DUTY_RATE = 0.05
    NEAREST_CENT = 1 / 0.05

    attr_reader :product_name, :quantity, :price, :price_post_tax, :sale_tax

    def initialize(product_name:, quantity:, price:)
      @product_name = product_name
      @quantity = quantity
      @price = price
      @sale_tax = cal_sale_tax
      @price_post_tax = cal_price_post_tax
    end

    def tax_exemptable?
      EXEMPT_TAX_IDENTICATION.any? do |word|
        product_name.squish.include?(word)
      end
    end

    def imported?
      IMPORTED_PRODUCT_IDENTICATION.any? do |word|
        product_name.squish.include?(word)
      end
    end

    def attributes_as_csv
      [quantity, product_name, " #{price_post_tax}"].to_csv
    end

    private

    def cal_sale_tax
      tax = 0.00
      tax = sale_base_tax unless tax_exemptable?
      tax += sale_import_duty if imported?

      round_up_to_nearest(tax)
    end

    def cal_price_post_tax
      total = sale_tax + price
      total.round(2)
    end

    def sale_base_tax
      price * BASE_TAX_RATE
    end

    def sale_import_duty
      price * IMPORT_DUTY_RATE
    end

    def round_up_to_nearest(num)
      (num * NEAREST_CENT).ceil / NEAREST_CENT
    end
  end
end
