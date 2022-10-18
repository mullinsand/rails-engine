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
  end
  
  describe 'class methods' do
    describe 'find_by_name' do
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
  end
end
