require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class methods' do
    describe 'find_only_item_invoices(params[:id])' do
      describe 'finds invoices that match input array id and have no items' do
        context 'only one invoice with no items' do
          it 'returns that invoice id in array named invoices' do
            item1 = create(:item)
            invoice1 = create(:invoice)
            invoice2 = create(:invoice)

            create(:invoice_item, item: item1, invoice: invoice2)
            create_list(:invoice_item, 2, invoice: invoice2)

            expect(Invoice.find_only_item_invoices([invoice1.id, invoice2.id])).to eq([invoice1.id])
            expect(Invoice.find_only_item_invoices([invoice1.id, invoice2.id])).to_not include(invoice2.id)
          end
        end

        context 'multiple invoices with no items' do
          it 'returns that invoice id in array named invoices' do
            item1 = create(:item)
            invoice1 = create(:invoice)
            invoice2 = create(:invoice)
            invoice3 = create(:invoice)
            invoice4 = create(:invoice)

            create(:invoice_item, item: item1, invoice: invoice2)
            create_list(:invoice_item, 2, invoice: invoice2)

            expect(Invoice.find_only_item_invoices([invoice1.id, invoice2.id, invoice3.id, invoice4.id])).to eq([invoice1.id, invoice3.id, invoice4.id])
            expect(Invoice.find_only_item_invoices([invoice1.id, invoice2.id, invoice3.id, invoice4.id])).to_not include(invoice2.id)
          end
        end

        context 'item has no invoices it is the only item on' do
          it 'returns an empty array' do
            item1 = create(:item)
            invoice2 = create(:invoice)

            create(:invoice_item, item: item1, invoice: invoice2)
            create_list(:invoice_item, 2, invoice: invoice2)

            expect(Invoice.find_only_item_invoices(invoice2.id)).to eq([])
          end
        end

        context 'inputs an empty array' do
          it 'returns an empty array' do
            item1 = create(:item)

            expect(Invoice.find_only_item_invoices([])).to eq([])
          end
        end
      end
    end
  end
end