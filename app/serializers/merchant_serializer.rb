class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  # def self.format_merchants(merchants)
    # all_merchants = merchants.map do |merchant|
    #   {
    #     id: merchant.id,
    #     name: merchant.name
    #   }
    # end
  # end
end