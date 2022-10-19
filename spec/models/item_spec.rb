require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  
  describe 'class methods' do
    describe 'find_by_name one' do
      context 'single matching item' do
        it 'finds a item by their name attribute' do
          first_item = create(:item, name: 'item1')
          second_item = create(:item, name: 'another one')

          expect(Item.find_by_name(first_item.name)).to eq(first_item)
        end

        it 'matches partial names' do
          first_item = create(:item, name: 'item1')
          create(:item, name: 'another one')

          expect(Item.find_by_name('tem')).to eq(first_item)
        end
      end

      context 'multiple matching results' do
        it 'sorts by alpha and returns the first one' do
          create(:item, name: 'andrews thing')
          second_item = create(:item, name: 'aarons thing')

          expect(Item.find_by_name('thing')).to eq(second_item)
        end
      end

      context 'no matching results' do
        it 'returns nil' do
          create(:item, name: 'andrews thing')
          create(:item, name: 'aarons thing')

          expect(Item.find_by_name('item')).to eq(nil)
        end
      end
    end

    describe 'find_by_name all' do
      context 'single matching item' do
        it 'finds a item by their name attribute' do
          first_item = create(:item, name: 'item1')
          second_item = create(:item, name: 'another one')

          expect(Item.find_by_name(first_item.name, 'all')).to eq([first_item])
        end

        it 'matches partial names' do
          first_item = create(:item, name: 'item1')
          create(:item, name: 'another one')

          expect(Item.find_by_name('tem', 'all')).to eq([first_item])
        end
      end

      context 'multiple matching results' do
        it 'sorts by alpha and returns all' do
          first_item = create(:item, name: 'andrews thing')
          second_item = create(:item, name: 'aarons thing')

          expect(Item.find_by_name('thing', 'all')).to eq([second_item, first_item])
        end
      end

      context 'no matching results' do
        it 'returns nil' do
          create(:item, name: 'andrews thing')
          create(:item, name: 'aarons thing')

          expect(Item.find_by_name('item', 'all')).to eq([])
        end
      end
    end

    describe 'find_by_price' do
      it 'returns an item that has a unit_price equal to or between the min and max parameters' do
        first_item = create(:item, name: 'item1', unit_price: 15.00)
        create(:item, name: 'another one', unit_price: 15.01)
        min_price = 14.00
        max_price = 15.00

        expect(Item.find_by_price(min_price, max_price)).to eq(first_item)
      end

      context 'max/min price are nil' do
        it 'assigns max as infinity' do
          first_item = create(:item, name: 'item1', unit_price: 500000000000.00)
          create(:item, name: 'another one', unit_price: 13.99)
          min_price = 14.00
          max_price = nil
  
          expect(Item.find_by_price(min_price, max_price)).to eq(first_item)
        end

        it 'assigns min as 0' do
          first_item = create(:item, name: 'item1', unit_price: 0)
          create(:item, name: 'another one', unit_price: 14.01)
          max_price = 14.00
          min_price = nil

          expect(Item.find_by_price(min_price, max_price)).to eq(first_item)
        end
      end

      context 'multiple items that fit parameters' do
        it 'sorts by alpha and returns the first one' do
          first_item = create(:item, name: 'aa item1', unit_price: 15.00)
          create(:item, name: 'another one', unit_price: 15.01)
          min_price = 14.00
          max_price = 15.04
  
          expect(Item.find_by_price(min_price, max_price)).to eq(first_item)
        end
      end

      context 'no matching results' do
        it 'returns nil' do
          create(:item, name: 'item1', unit_price: 13.99)
          create(:item, name: 'another one', unit_price: 15.00)
          min_price = 14.00
          max_price = 14.99

          expect(Item.find_by_price(min_price, max_price)).to eq(nil)
        end
      end
    end

    describe 'find_by_price all' do
      it 'returns an item that has a unit_price equal to or between the min and max parameters' do
        first_item = create(:item, name: 'item1', unit_price: 15.00)
        create(:item, name: 'another one', unit_price: 15.01)
        min_price = 14.00
        max_price = 15.00

        expect(Item.find_by_price(min_price, max_price, 'all')).to eq([first_item])
      end

      context 'max/min price are nil' do
        it 'assigns max as infinity' do
          first_item = create(:item, name: 'item1', unit_price: 500000000000.00)
          create(:item, name: 'another one', unit_price: 13.99)
          min_price = 14.00
          max_price = nil
  
          expect(Item.find_by_price(min_price, max_price, 'all')).to eq([first_item])
        end

        it 'assigns min as 0' do
          first_item = create(:item, name: 'item1', unit_price: 0)
          create(:item, name: 'another one', unit_price: 14.01)
          max_price = 14.00
          min_price = nil

          expect(Item.find_by_price(min_price, max_price, 'all')).to eq([first_item])
        end
      end

      context 'multiple items that fit parameters' do
        it 'sorts by alpha and returns them all' do
          first_item = create(:item, name: 'aa item1', unit_price: 15.00)
          second_item = create(:item, name: 'another one', unit_price: 15.01)
          min_price = 14.00
          max_price = 15.04
  
          expect(Item.find_by_price(min_price, max_price, 'all')).to eq([first_item, second_item])
        end
      end

      context 'no matching results' do
        it 'returns nil' do
          create(:item, name: 'item1', unit_price: 13.99)
          create(:item, name: 'another one', unit_price: 15.00)
          min_price = 14.00
          max_price = 14.99

          expect(Item.find_by_price(min_price, max_price, 'all')).to eq([])
        end
      end
    end

    describe 'negative prices?' do
      context 'either min or max are negative numbers' do
        it 'returns true' do
          min_price = 14.00
          max_price = -5
  
          expect(Item.negative_prices?(min_price, max_price)).to eq(true)
        end

        it 'returns true' do
          max_price = 14.00
          min_price = -5
  
          expect(Item.negative_prices?(min_price, max_price)).to eq(true)
        end

        it 'returns true' do
          max_price = -14.00
          min_price = -5
  
          expect(Item.negative_prices?(min_price, max_price)).to eq(true)
        end
      end

      context 'both min and max are positive numbers' do
        it 'returns false' do
          min_price = 14.00
          max_price = 27.00
  
          expect(Item.negative_prices?(min_price, max_price)).to eq(false)
        end
      end

      context 'max/min price are nil' do
        it 'assigns max as 0' do
          min_price = 14.00
          max_price = nil
  
          expect(Item.negative_prices?(min_price, max_price)).to eq(false)
        end

        it 'assigns min as 0' do
          max_price = 14.00
          min_price = nil

          expect(Item.negative_prices?(min_price, max_price)).to eq(false)
        end
      end
    end

    describe 'find_only_item_invoices(params[:id])' do
      describe 'finds all invoices that only have that item on the invoice' do
        context 'item is only item on an invoice' do
          it 'returns that invoice id in array named invoices' do
            item1 = create(:item)
            invoice1 = create(:invoice)
            invoice2 = create(:invoice)

            create(:invoice_item, item: item1, invoice: invoice1)
            create(:invoice_item, item: item1, invoice: invoice2)
            create_list(:invoice_item, 2, invoice: invoice2)

            expect(Item.find_only_item_invoices(item1.id)).to eq([invoice1.id])
            expect(Item.find_only_item_invoices(item1.id)).to_not include(invoice2.id)
          end
        end

        context 'item is only item on multiple invoices' do
          it 'returns that invoice id in array named invoices' do
            item1 = create(:item)
            invoice1 = create(:invoice)
            invoice2 = create(:invoice)
            invoice3 = create(:invoice)
            invoice4 = create(:invoice)


            create(:invoice_item, item: item1, invoice: invoice1)
            create(:invoice_item, item: item1, invoice: invoice2)
            create(:invoice_item, item: item1, invoice: invoice3)
            create(:invoice_item, item: item1, invoice: invoice4)
            create_list(:invoice_item, 2, invoice: invoice2)

            expect(Item.find_only_item_invoices(item1.id)).to eq([invoice1.id, invoice3.id, invoice4.id])
            expect(Item.find_only_item_invoices(item1.id)).to_not include(invoice2.id)
          end
        end

        context 'item has no invoices it is the only item on' do
          it 'returns an empty array' do
            item1 = create(:item)
            invoice2 = create(:invoice)

            create(:invoice_item, item: item1, invoice: invoice2)
            create_list(:invoice_item, 2, invoice: invoice2)

            expect(Item.find_only_item_invoices(item1.id)).to eq([])
          end
        end

        context 'item has no invoices' do
          it 'returns an empty array' do
            item1 = create(:item)

            expect(Item.find_only_item_invoices(item1.id)).to eq([])
          end
        end
      end
    end
  end
end
