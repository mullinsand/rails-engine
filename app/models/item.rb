class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id
  
  belongs_to :merchant

  def self.find_by_name(string)
    where("name ILIKE ?", "%#{string}%").order(:name).limit(1).first
  end
end
