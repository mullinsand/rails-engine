class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id

  around_destroy :delete_only_item_invoices

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.find_by_name(string, condition = 'one')
    search_results = where('name ILIKE ?', "%#{string}%").order(:name)
    condition == 'all' ? search_results : search_results.first
  end

  def self.find_by_price(min_price, max_price, condition = 'one')
    min_price ||= 0
    max_price ||= Float::INFINITY

    search_results = where('unit_price >= ? and unit_price <= ?', min_price, max_price).order(:name)
    condition == 'all' ? search_results : search_results.first
  end

  def self.negative_prices?(min_price, max_price)
    min_price ||= 0
    max_price ||= 0
    min_price.to_f.negative? || max_price.to_f.negative?
  end

  private

  def delete_only_item_invoices
    item_invoices = invoices.pluck(:id)
    yield
    Invoice.delete_only_item_invoices(item_invoices)
  end
end
