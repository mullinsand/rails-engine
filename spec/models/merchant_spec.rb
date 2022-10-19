require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'class methods' do
    describe 'find_by_name' do
      context 'single matching merchant' do
        it 'finds a merchant by their name attribute' do
          first_merchant = create(:merchant, name: 'merchant1')
          second_merchant = create(:merchant, name: 'another one')

          expect(Merchant.find_by_name(first_merchant.name)).to eq(first_merchant)
        end

        it 'matches partial names' do
          first_merchant = create(:merchant, name: 'merchant1')
          create(:merchant, name: 'another one')

          expect(Merchant.find_by_name('chant')).to eq(first_merchant)
        end
      end

      context 'multiple matching results' do
        it 'sorts by alpha and returns the first one' do
          create(:merchant, name: 'andrews thing')
          second_merchant = create(:merchant, name: 'aarons thing')

          expect(Merchant.find_by_name('thing')).to eq(second_merchant)
        end
      end

      context 'no matching results' do
        it 'returns nil' do
          create(:merchant, name: 'andrews thing')
          create(:merchant, name: 'aarons thing')

          expect(Merchant.find_by_name('merchant')).to eq(nil)
        end
      end
    end
  end
end
