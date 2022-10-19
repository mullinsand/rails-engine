FactoryBot.define do
  factory :invoice_item do
    quantity { rand(150) }
    unit_price { rand(50..20000)}
    invoice
    item
  end
end 