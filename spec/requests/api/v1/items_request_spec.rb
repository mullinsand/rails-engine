require 'rails_helper'

describe 'Items API' do
  describe 'Get All Items' do
    it 'sends a list of all items' do

      create_list(:item, 7)

      get "/api/v1/items"
      
      expect(response).to be_successful
      expect(json[:data].count).to eq(7)

      json[:data].each do |item|
        expect(item).to have_key(:id)
        # expect(item[:attributes][:id]).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it 'returns status code 200' do
      create_list(:item, 3)

      get "/api/v1/items"

      expect(response).to have_http_status(200)
    end

    context 'if there are no items' do
      it 'returns an empty array' do

        get "/api/v1/items"

        expect(json[:data]).to eq([])
      end
    end
  end

  describe 'Get One Item' do
    it 'returns a single item' do
      item1 = create(:item, name: "Bob")
      create_list(:item, 3)

      get "/api/v1/items/#{item1.id}"
      expect(response).to be_successful
      item = json[:data]
      expect(item).to be_a(Hash)
      expect(item).to have_key(:id)
      # expect(item[:attributes][:id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end

    it 'returns status code 200' do
      item1 = create(:item)
      get "/api/v1/items/#{item1.id}"

      expect(response).to have_http_status(200)
    end

    context 'if there are no items with that id' do
      it 'returns a 404 status response' do
        get '/api/v1/items/24'

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Get an items merchant' do
    it 'returns the merchant for an item' do
      merchant1 = create(:merchant, name: "Bob")

      item1 = create(:item, merchant: merchant1)

      get "/api/v1/items/#{item1.id}/merchant"
      
      expect(response).to be_successful
      expect(json[:data]).to be_a(Hash)

      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(merchant1.name)
      end
    end

    it 'returns status code 200' do
      merchant1 = create(:merchant, name: "Bob")

      create_list(:item, 3, merchant: merchant1)

      get "/api/v1/merchants/#{merchant1.id}/items"

      expect(response).to have_http_status(200)
    end

    context 'if merchant has no items' do
      it 'returns an empty array' do
        merchant1 = create(:merchant, name: "Bob")

        get "/api/v1/merchants/#{merchant1.id}/items"

        expect(json[:data]).to eq([])
      end
    end

    context 'if merchant does not exist' do  
      it 'returns a 404 status response' do
        get "/api/v1/merchants/50/items"

        expect(response).to have_http_status(404)
      end
    end
  end
end