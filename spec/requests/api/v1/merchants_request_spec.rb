require 'rails_helper'

describe 'Merchants API' do
  describe 'Get All Merchants' do
    it 'sends a list of merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'
      expect(response).to be_successful
      expect(json[:data].count).to eq(3)

      json[:data].each do |merchant|
        # expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns status code 200' do
      get '/api/v1/merchants'

      expect(response).to have_http_status(200)
    end

    context 'if there are no merchants' do
      it 'returns an empty array' do
        get '/api/v1/merchants'

        expect(json[:data]).to eq([])
      end
    end
  end

  describe 'Get One Merchant' do
    it 'returns a single merchant' do
      merchant1 = create(:merchant, name: "Bob")
      create_list(:merchant, 3)

      get "/api/v1/merchants/#{merchant1.id}"
      expect(response).to be_successful
      expect(json[:data]).to be_a(Hash)

      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(merchant1.name)

    end

    it 'returns status code 200' do
      merchant1 = create(:merchant, name: "Bob")
      get "/api/v1/merchants/#{merchant1.id}"

      expect(response).to have_http_status(200)
    end

    context 'if there are no merchants with that id' do
      it 'returns a 404 status response' do
        get '/api/v1/merchants/24'

        expect(response).to have_http_status(404)
      end
    end
  end
end