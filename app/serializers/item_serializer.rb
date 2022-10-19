class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id
  # belongs_to :merchant

  def find_one_item
    
  end
end
