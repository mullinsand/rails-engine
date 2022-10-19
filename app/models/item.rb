class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id
  
  belongs_to :merchant

  def self.find_by_name(string)
    where("name ILIKE ?", "%#{string}%")
      .order(:name)
      .limit(1)
      .first
  end

  def self.find_by_price(min_price, max_price)
    min_price ||= 0
    max_price ||= Float::INFINITY

    where("unit_price >= ? and unit_price <= ?", min_price, max_price)
      .order(:name)
      .limit(1)
      .first
  end

  def self.negative_prices?(min_price, max_price)
    min_price ||= 0
    max_price ||= 0
    min_price.to_f.negative? || max_price.to_f.negative?
  end
end
