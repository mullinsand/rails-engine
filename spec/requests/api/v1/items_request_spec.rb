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

    it 'returns status code 200' do
      merchant1 = create(:merchant, name: "Bob")

      item1 = create(:item, merchant: merchant1)

      get "/api/v1/items/#{item1.id}/merchant"

      expect(response).to have_http_status(200)
    end

    context 'if item does not exist' do  
      it 'returns a 404 status response' do
        get "/api/v1/items/50/merchant"

        expect(response).to have_http_status(404)
      end
    end

    context 'if string is used instead of a number' do
      it 'returns a 404 status response' do
        get "/api/v1/items/bob/merchant"

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'create an item' do
    it 'can create a new item' do
      merchant1 = create(:merchant)
      item_params = ({
        name: "thing",
        description: "the best thing eva",
        unit_price: "12345",
        merchant_id: merchant1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful

      expect(created_item.name).to eq(item_params[:name])

      expect(created_item.description).to eq(item_params[:description])

      expect(created_item.unit_price).to eq(item_params[:unit_price].to_f)

      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'returns status code 201' do
      merchant1 = create(:merchant)

      item_params = ({
        name: "thing",
        description: "the best thing eva",
        unit_price: "12345",
        merchant_id: merchant1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(201)
    end

    context 'attributes missing' do
      it 'returns a 400 and error message' do
        merchant1 = create(:merchant)

        item_params = ({
          name: "thing",
          description: "the best thing eva",
          merchant_id: merchant1.id
        })
        # no unit price
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

        expect(response).to have_http_status(422)

        expect(json[:errors]).to eq("Validation failed: Unit price can't be blank")
      end
    end
  end


  describe 'update an item' do
    it 'can update a new item' do
      id = create(:item).id
      previous_name = Item.last.name
      previous_description = Item.last.description
      item_params = { name: "Bestest item eva" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
      item = Item.find(id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)

      expect(item.name).to eq("Bestest item eva")

      expect(item.description).to eq(previous_description)
    end

    it 'returns status code 200' do
      item = create(:item, name: "og thing")
      item_params = {name: "thing"}
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(200)
    end

    context 'if item does not exist' do  
      it 'returns a 404 status response' do
        item_params = {name: "thing"}
        headers = {"CONTENT_TYPE" => "application/json"}
  
        patch "/api/v1/items/50", headers: headers, params: JSON.generate(item: item_params)

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'delete an item' do
    it 'can delete an item' do
      bad_item = create(:item)
      create_list(:item, 3)

      expect { delete "/api/v1/items/#{bad_item.id}" }.to change(Item, :count).by(-1)

      expect(response).to be_successful
      expect { Item.find(bad_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'deletes any invoices that that item is the only item on' do
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

      delete "/api/v1/items/#{item1.id}"

      expect(Invoice.all).to include(invoice2)
      expect(Invoice.all).to_not include(invoice1)
      expect(Invoice.all).to_not include(invoice3)
      expect(Invoice.all).to_not include(invoice4)
    end

    context 'if item does not exist' do  
      it 'returns a 404 status response' do
  
        delete "/api/v1/items/100"

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'single item search' do
    it 'find an item based on name search params results in alpha order' do
      cool_item = create(:item, name: "rings")
      create_list(:item, 3, name: "shoes")
      not_cool_item = create(:item, name: "springs")
      search_name = "ring"

      get "/api/v1/items/find?name=#{search_name}"

      expect(response).to be_successful

      item = json[:data]
      expect(item).to be_a(Hash)
      expect(item).to have_key(:id)
      # expect(item[:attributes][:id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq(cool_item.name)
      expect(item[:attributes][:name]).to_not eq(not_cool_item.name)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end

    context 'if item search returns no results' do  
      it 'returns a 200 with a message' do
  
        cool_item = create(:item, name: "rings")
        create_list(:item, 3, name: "shoes")
        not_cool_item = create(:item, name: "springs")
        search_name = "fire"
  
        get "/api/v1/items/find?name=#{search_name}"

        expect(response).to be_successful

        expect(json[:data]).to eq({})
      end
    end
  end

  describe 'all item search' do
    it 'find all items based on name search params results in alpha order' do
      cool_item = create(:item, name: "rings")
      create_list(:item, 3, name: "shoes")
      not_cool_item = create(:item, name: "springs")
      search_name = "ring"

      get "/api/v1/items/find_all?name=#{search_name}"

      expect(response).to be_successful
      expect(json[:data].count).to eq(2)
      json[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        # expect(item[:attributes][:id]).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:name]).to_not eq('shoes')

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    context 'if item search returns no results' do  
      it 'returns a 200 with a message' do
  
        cool_item = create(:item, name: "rings")
        create_list(:item, 3, name: "shoes")
        not_cool_item = create(:item, name: "springs")
        search_name = "fire"
  
        get "/api/v1/items/find_all?name=#{search_name}"

        expect(response).to be_successful

        expect(json[:data]).to eq([])
      end
    end
  end

  describe 'min/max item price search' do
    describe 'min item price search one' do
      it 'finds an item based on min search params results in alpha order' do
        cool_item = create(:item, name: "Andrew's thing", unit_price: "50.00")
        create_list(:item, 3, name: "freds things", unit_price: "100.00")
        not_cool_item = create(:item, name: "Aaron's thing", unit_price: "49.99")
        search_unit_price = "50.00"

        get "/api/v1/items/find?min_price=#{search_unit_price}"

        expect(response).to be_successful

        item = json[:data]
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        # expect(item[:attributes][:id]).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq(cool_item.name)
        expect(item[:attributes][:name]).to_not eq(not_cool_item.name)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      context 'if item search returns no results' do  
        it 'returns a 200 with a message' do
  
          search_unit_price = "50.00"
  
          get "/api/v1/items/find?min_price=#{search_unit_price}"
  
          expect(response).to be_successful
  
          expect(json[:data]).to eq({})

        end
      end

      describe 'min item price search all' do
        it 'finds all items based on min search params results in alpha order' do
          cool_item = create(:item, name: "Andrew's thing", unit_price: "50.00")
          create_list(:item, 3, name: "freds things", unit_price: "100.00")
          not_cool_item = create(:item, name: "Aaron's thing", unit_price: "49.99")
          search_unit_price = "50.00"
  
          get "/api/v1/items/find_all?min_price=#{search_unit_price}"
  
          expect(response).to be_successful
  
          expect(json[:data].count).to eq(4)
          json[:data].each do |item|
            expect(item).to be_a(Hash)
            expect(item).to have_key(:id)
            # expect(item[:attributes][:id]).to be_an(Integer)

            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)
            expect(item[:attributes][:name]).to_not eq("Aaron's thing")

            expect(item[:attributes]).to have_key(:description)
            expect(item[:attributes][:description]).to be_a(String)

            expect(item[:attributes]).to have_key(:unit_price)
            expect(item[:attributes][:unit_price]).to be_a(Float)

            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
          end
        end
  
        context 'if item search returns no results' do  
          it 'returns a 200 with an array' do
    
            search_unit_price = "50.00"
    
            get "/api/v1/items/find_all?min_price=#{search_unit_price}"
    
            expect(response).to be_successful
    
            expect(json[:data]).to eq([])
  
          end
        end
      end
    end

    describe 'max item price search one' do
      it 'find an item based on max search params results in alpha order' do
        cool_item = create(:item, name: "Andrew's thing", unit_price: "49.99")
        create_list(:item, 3, name: "freds things", unit_price: "40.00")
        not_cool_item = create(:item, name: "Aaron's thing", unit_price: "50.01")
        search_unit_price = "50.00"

        get "/api/v1/items/find?max_price=#{search_unit_price}"

        expect(response).to be_successful

        item = json[:data]
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        # expect(item[:attributes][:id]).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq(cool_item.name)
        expect(item[:attributes][:name]).to_not eq(not_cool_item.name)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      context 'if item search returns no results' do  
        it 'returns a 200 with a message' do
  
          search_unit_price = "50.00"
  
          get "/api/v1/items/find?max_price=#{search_unit_price}"
  
          expect(response).to be_successful
  
          expect(json[:data]).to eq({})
        end
      end
    end

    describe 'max item price search all' do
      it 'finds all items based on max search params results in alpha order' do
        cool_item = create(:item, name: "Andrew's thing", unit_price: "49.99")
        create_list(:item, 3, name: "freds things", unit_price: "40.00")
        not_cool_item = create(:item, name: "Aaron's thing", unit_price: "50.01")
        search_unit_price = "50.00"

        get "/api/v1/items/find_all?max_price=#{search_unit_price}"

        expect(response).to be_successful

        expect(json[:data].count).to eq(4)
        json[:data].each do |item|
          expect(item).to be_a(Hash)
          expect(item).to have_key(:id)
          # expect(item[:attributes][:id]).to be_an(Integer)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)
          expect(item[:attributes][:name]).to_not eq("Aaron's thing")

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)

          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_an(Integer)
        end
      end

      context 'if item search returns no results' do  
        it 'returns a 200 with an array' do
  
          search_unit_price = "50.00"
  
          get "/api/v1/items/find_all?max_price=#{search_unit_price}"
  
          expect(response).to be_successful
  
          expect(json[:data]).to eq([])

        end
      end
    end

    describe 'max/min item price search one' do
      it 'find an item based on max and min search params results in alpha order' do
        cool_item = create(:item, name: "Andrew's thing", unit_price: "50.00")
        create_list(:item, 3, name: "freds things", unit_price: "50.00")
        not_cool_item = create(:item, name: "Aaron's thing", unit_price: "50.02")
        search_min_unit_price = "50.00"
        search_max_unit_price = "50.00"

        get "/api/v1/items/find?max_price=#{search_max_unit_price}&min_price=#{search_min_unit_price}"

        expect(response).to be_successful

        item = json[:data]
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        # expect(item[:attributes][:id]).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq(cool_item.name)
        expect(item[:attributes][:name]).to_not eq(not_cool_item.name)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      context 'if item search returns no results' do  
        it 'returns a 200 with a message' do
  
          search_min_unit_price = "50.00"
          search_max_unit_price = "50.00"
  
          get "/api/v1/items/find?max_price=#{search_max_unit_price}&min_price=#{search_min_unit_price}"

          expect(response).to be_successful
  
          expect(json[:data]).to eq({})
        end
      end

      context 'if min/max price are negative' do  
        it 'returns an error message' do
  
          search_unit_price = "-50.00"
  
          get "/api/v1/items/find?max_price=#{search_unit_price}"

          expect(response.status).to eq(400)
          expect(json[:errors]).to eq('Prices must be greater than or equal to zero')
        end
      end

      context 'if min/max price are not present' do  
        it 'returns an error message' do
  
          search_unit_price = ""
  
          get "/api/v1/items/find?max_price=#{search_unit_price}"

          expect(response.status).to eq(400)
          expect(json[:errors]).to eq('No params listed in search')
        end
      end

      context 'if name and price params are present' do  
        it 'returns an error message' do
  
          search_unit_price = ""
          search_name = "bob"
  
          get "/api/v1/items/find?max_price=#{search_unit_price}&name=#{search_name}"

          expect(response.status).to eq(400)
          expect(json[:errors]).to eq('Name and price cannot be used on the same request')
        end
      end

      context 'if min is greater than max' do  
        it 'returns an error message' do
  
          search_min_unit_price = "50.00"
          search_max_unit_price = "49.99"
  
          get "/api/v1/items/find_all?max_price=#{search_max_unit_price}&min_price=#{search_min_unit_price}"

          expect(response.status).to eq(400)
          expect(json[:errors]).to eq('Price minimum must be greater than maximum')
        end
      end
    end

    describe 'max/min item price search all' do
      it 'finds all items based on min/max search params results in alpha order' do
        cool_item = create(:item, name: "Andrew's thing", unit_price: "50.00")
        create_list(:item, 3, name: "freds things", unit_price: "50.00")
        not_cool_item = create(:item, name: "Aaron's thing", unit_price: "50.02")
        search_min_unit_price = "50.00"
        search_max_unit_price = "50.00"

        get "/api/v1/items/find_all?max_price=#{search_max_unit_price}&min_price=#{search_min_unit_price}"

        expect(response).to be_successful

        expect(json[:data].count).to eq(4)
        json[:data].each do |item|
          expect(item).to be_a(Hash)
          expect(item).to have_key(:id)
          # expect(item[:attributes][:id]).to be_an(Integer)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)
          expect(item[:attributes][:name]).to_not eq("Aaron's thing")

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)

          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_an(Integer)
        end
      end

      context 'if item search returns no results' do  
        it 'returns a 200 with a message' do
  
          search_min_unit_price = "50.00"
          search_max_unit_price = "50.00"
  
          get "/api/v1/items/find_all?max_price=#{search_max_unit_price}&min_price=#{search_min_unit_price}"

          expect(response).to be_successful
  
          expect(json[:data]).to eq([])
        end
      end

      context 'if min/max price are not present' do  
        it 'returns an error message' do
  
          search_unit_price = ""
  
          get "/api/v1/items/find_all?max_price=#{search_unit_price}"

          expect(response.status).to eq(400)
          expect(json[:errors]).to eq('No params listed in search')
        end
      end

      context 'if name and price params are present' do  
        it 'returns an error message' do
  
          search_unit_price = ""
          search_name = "bob"
  
          get "/api/v1/items/find_all?max_price=#{search_unit_price}&name=#{search_name}"

          expect(response.status).to eq(400)
          expect(json[:errors]).to eq('Name and price cannot be used on the same request')
        end
      end
    end
  end

  describe 'pagination of all items response' do
    describe 'renders one page at a time' do
      context 'if no page params sent' do
        it 'defaults to page 1 with 20 results' do
          first_item = create(:item, name: "a thingamajig")
          create_list(:item, 18)
          last_item = create(:item)
          page = ""
          per_page = ""

          get "/api/v1/items?page=#{page}&per_page=#{per_page}"

          expect(json[:data].count).to eq(20)
          expect(json[:data].first[:attributes][:name]).to eq(first_item.name)
          expect(json[:data].last[:attributes][:name]).to eq(last_item.name)
        end
      end

      context 'if just page params sent' do
        it 'defaults to 20 results per page' do
          create_list(:item, 60)
          first_item = create(:item, name: "a thingamajig")
          create_list(:item, 18)
          last_item = create(:item)
          page = 4


          get "/api/v1/items?page=#{page}"

          expect(json[:data].count).to eq(20)
          expect(json[:data].first[:attributes][:name]).to eq(first_item.name)
          expect(json[:data].last[:attributes][:name]).to eq(last_item.name)
        end
      end

      context 'if just results per page params sent' do
        it 'defaults to page 1' do
          first_item = create(:item, name: "a thingamajig")
          create_list(:item, 47)
          last_item = create(:item)
          per_page = 49

          get "/api/v1/items?per_page=#{per_page}"

          expect(json[:data].count).to eq(49)
          expect(json[:data].first[:attributes][:name]).to eq(first_item.name)
          expect(json[:data].last[:attributes][:name]).to eq(last_item.name)
        end
      end

      context 'if both results_per_page and page params sent' do
        it 'returns results following those params' do
          create_list(:item, 15)
          first_item = create(:item, name: "a thingamajig")
          create_list(:item, 13)
          last_item = create(:item)
          page = 2
          per_page = 15

          get "/api/v1/items?page=#{page}&per_page=#{per_page}"

          expect(json[:data].count).to eq(15)
          expect(json[:data].first[:attributes][:name]).to eq(first_item.name)
          expect(json[:data].last[:attributes][:name]).to eq(last_item.name)
        end
      end

      context 'if results window is less than results_per_page' do
        it 'returns results less than the results per page' do
          create_list(:item, 17)
          first_item = create(:item, name: "a thingamajig")
          create_list(:item, 11)
          last_item = create(:item)
          page = 2
          per_page = 17

          get "/api/v1/items?page=#{page}&per_page=#{per_page}"

          expect(json[:data].count).to eq(13)
          expect(json[:data].first[:attributes][:name]).to eq(first_item.name)
          expect(json[:data].last[:attributes][:name]).to eq(last_item.name)
        end
      end
    end
  end
end