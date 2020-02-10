# frozen_string_literal: true

RSpec.describe TaxCalculator::ReceiptItem do
  let(:item) do
    TaxCalculator::ReceiptItem.new(
      product_name: product_name,
      quantity: 1,
      price: 10.00
    )
  end

  describe "#tax_exemptable?" do
    context "Product is the exempted good" do
      let(:product_name) { "book" }
      it { expect(item.tax_exemptable?).to be_truthy }
    end

    context "Product is not the exempted good" do
      let(:product_name) { "music CD" }
      it { expect(item.tax_exemptable?).to be_falsy }
    end
  end

  describe "#imported?" do
    context "Product is the imported good" do
      let(:product_name) { "imported book" }
      it { expect(item.imported?).to be_truthy }
    end

    context "Product is not the imported good" do
      let(:product_name) { "book" }
      it { expect(item.imported?).to be_falsy }
    end
  end

  describe "#attributes_as_csv" do
    let(:product_name) { " imported book" }
    it do
      result = "1, imported book, 10.50\n"
      expect(item.attributes_as_csv).to eq result
    end
  end

  describe "private methods" do
    describe "#round_up_to_nearest" do
      let(:product_name) { "book" }
      context "2th decimal is less than nearst 0.05" do
        it "returns rounded value with 2 decimal places to the nearst" do
          expect(item.send(:round_up_to_nearest, 8.63555)).to eq 8.65
        end
      end
      context "2th decimal is equal nearst 0.05" do
        it "returns rounded value with to the nearst" do
          expect(item.send(:round_up_to_nearest, 8.6523)).to eq 8.70
        end
      end
    end
    describe "#cal_price_post_tax" do
      context "Product is exempted tax" do
        context "Product is imported good" do
          let(:product_name) { "imported book" }
          it "returns total price included taxes" do
            expect(item.send(:cal_price_post_tax)).to eq 10.50
          end
        end
        context "Product is not imported good" do
          let(:product_name) { "book" }
          it "returns total price included taxes" do
            expect(item.send(:cal_price_post_tax)).to eq 10.0
          end
        end
      end
      context "Product is not exempted tax" do
        context "Product is imported good" do
          let(:product_name) { "imported music CD" }
          it "returns total price included taxes" do
            expect(item.send(:cal_price_post_tax)).to eq 11.5
          end
        end
        context "Product is not imported good" do
          let(:product_name) { "music CD" }
          it "returns total price included taxes" do
            expect(item.send(:cal_price_post_tax)).to eq 11.0
          end
        end
      end
    end
    describe "#cal_sale_tax" do
      context "Product is exempted good" do
        context "Product is imported good" do
          let(:product_name) { "imported chocolate" }
          it do
            expect(item).not_to receive(:sale_base_tax)
            expect(item).to receive(:sale_import_duty).and_call_original
            sale_tax = item.send(:cal_sale_tax)

            expect(sale_tax).to eq 0.5
          end
        end
        context "Product is not imported good" do
          let(:product_name) { "chocolate" }
          it do
            expect(item).not_to receive(:sale_base_tax)
            expect(item).not_to receive(:sale_import_duty)
            sale_tax = item.send(:cal_sale_tax)

            expect(sale_tax).to eq 0.0
          end
        end
      end
      context "Product is not exempted good" do
        context "Product is imported good" do
          let(:product_name) { "imported music CD" }
          it do
            expect(item).to receive(:sale_base_tax).and_call_original
            expect(item).to receive(:sale_import_duty).and_call_original
            sale_tax = item.send(:cal_sale_tax)

            expect(sale_tax).to eq 1.5
          end
        end
        context "Product is not imported good" do
          let(:product_name) { "music CD" }
          it do
            expect(item).to receive(:sale_base_tax).and_call_original
            expect(item).not_to receive(:sale_import_duty)
            sale_tax = item.send(:cal_sale_tax)

            expect(sale_tax).to eq 1.0
          end
        end
      end
    end
  end
end
