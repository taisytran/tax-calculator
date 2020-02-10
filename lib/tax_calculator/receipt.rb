# frozen_string_literal: true

require "csv"

module TaxCalculator
  class Receipt
    INPUT_DIR = "input"

    def initialize(filename)
      @filename = filename
    end

    def print
      puts receipt_items.map(&:attributes_as_csv)
      puts "Sales Taxes: #{sale_tax}"
      puts "Total: #{total}"
    end

    def sale_tax
      format("%.2f", receipt_items.sum(&:sale_tax))
    end

    def total
      format("%.2f", receipt_items.sum(&:price_post_tax))
    end

    private

    def receipt_items
      @receipt_items ||= parse_data
    end

    def csv_file
      input_path = "#{Dir.pwd}/#{INPUT_DIR}/#{@filename}.txt"
      File.new(input_path)
    end

    def read_from_input
      csv_opts = {
        headers: true,
        encoding: "UTF-8",
        skip_blanks: true
      }
      CSV.table(csv_file.path, **csv_opts)
    end

    def parse_data
      receipt_items = []
      raw_data = read_from_input
      raw_data.each do |row|
        receipt_items << ReceiptItem.new(
          product_name: row[:product],
          quantity: row[:quantity],
          price: row[:price]
        )
      end

      receipt_items
    end
  end
end
