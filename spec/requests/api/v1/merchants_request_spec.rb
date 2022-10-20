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

  describe 'Get All Merchants items' do
    it 'sends a list of merchants items' do
      merchant1 = create(:merchant, name: "Bob")

      create_list(:item, 3, merchant: merchant1)

      get "/api/v1/merchants/#{merchant1.id}/items"
      
      expect(response).to be_successful
      expect(json[:data].count).to eq(3)

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
        expect(item[:attributes][:merchant_id]).to eq(merchant1.id)
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

  describe 'Search for all Merchants by name' do
    it 'makes a list of merchants whose names match a string' do
      create(:merchant, name: "Fred")
      create(:merchant, name: "Ted")
      create_list(:merchant, 4, name: "Bob")
      name_search = "ed"
      get "/api/v1/merchants/find_all?name=#{name_search}"
      expect(response).to be_successful

      expect(json[:data].count).to eq(2)

      json[:data].each do |merchant|
        # expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns status code 200' do
      create(:merchant, name: "Fred")
      create(:merchant, name: "Ted")
      create_list(:merchant, 4, name: "Bob")
      name_search = "ed"
      get "/api/v1/merchants/find_all?name=#{name_search}"

      expect(response).to have_http_status(200)
    end

    context 'if there are no merchants' do
      it 'returns an empty array' do
        name_search = "ed"
        get "/api/v1/merchants/find_all?name=#{name_search}"

        expect(json[:data]).to eq([])
      end
    end

    context 'if search params are empty' do
      it 'returns an empty array' do
        name_search = "ed"
        get "/api/v1/merchants/find_all?name="

        expect(response.status).to eq(400)
        expect(json[:errors]).to eq('No params listed in search')
      end

      it 'returns an empty array' do
        name_search = "ed"
        get "/api/v1/merchants/find_all?"

        expect(response.status).to eq(400)
        expect(json[:errors]).to eq('No params listed in search')
      end
    end
  end

  describe 'Search for one Merchant by name' do
    it 'makes a list of merchants whose names match a string' do
      merchant1 = create(:merchant, name: "Fred")
      create(:merchant, name: "Ted")
      create_list(:merchant, 4, name: "Bob")
      name_search = "ed"
      get "/api/v1/merchants/find?name=#{name_search}"
      expect(response).to be_successful

      merchant = json[:data]
      expect(merchant).to be_a(Hash)
      expect(merchant).to have_key(:id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq(merchant1.name)

        # expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)
    end

    it 'returns status code 200' do
      create(:merchant, name: "Fred")
      create(:merchant, name: "Ted")
      create_list(:merchant, 4, name: "Bob")
      name_search = "ed"
      get "/api/v1/merchants/find?name=#{name_search}"

      expect(response).to have_http_status(200)
    end

    context 'if there are no merchants' do
      it 'returns a 200 with a message' do
        name_search = "ed"
        get "/api/v1/merchants/find?name=#{name_search}"

        expect(response).to be_successful

        expect(json[:data]).to eq({})
      end
    end

    context 'if search params are empty' do
      it 'returns an empty array' do
        name_search = "ed"
        get "/api/v1/merchants/find?name="

        expect(response.status).to eq(400)
        expect(json[:errors]).to eq('No params listed in search')
      end

      it 'returns an empty array' do
        name_search = "ed"
        get "/api/v1/merchants/find?"

        expect(response.status).to eq(400)
        expect(json[:errors]).to eq('No params listed in search')
      end
    end
  end
end