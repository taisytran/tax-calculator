# frozen_string_literal: true

RSpec.describe TaxCalculator::Receipt do
  let(:receipt) { TaxCalculator::Receipt.new(filename) }

  describe "#print" do
    context "filename is input1" do
      let(:filename) { "input1" }
      it "returns csv standard output" do
        result = <<~RESULT
          1, book, 12.49
          1, music CD, 16.49
          1, chocolate bar, 0.85
          Sales Taxes: 1.50
          Total: 29.83
        RESULT
        expect do
          receipt.print
        end.to output(result).to_stdout
      end
    end
    context "filename is input2" do
      let(:filename) { "input2" }
      it "returns csv standard output" do
        result = <<~RESULT
          1, imported box of chocolates, 10.50
          1, imported bottle of perfume, 54.65
          Sales Taxes: 7.65
          Total: 65.15
        RESULT
        expect do
          receipt.print
        end.to output(result).to_stdout
      end
    end
    context "filename is input3" do
      let(:filename) { "input3" }
      it "returns csv standard output" do
        result = <<~RESULT
          1, imported bottle of perfume, 32.19
          1, bottle of perfume, 20.89
          1, packet of headache pills, 9.75
          1, box of imported chocolates, 11.85
          Sales Taxes: 6.70
          Total: 74.68
        RESULT
        expect do
          receipt.print
        end.to output(result).to_stdout
      end
    end
  end
end
