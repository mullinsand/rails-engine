class Invoice < ApplicationRecord
  validates_presence_of :status
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.find_only_item_invoices(item_invoices)
    left_joins(:invoice_items)
      .where('invoices.id IN (?)', item_invoices)
      .select('invoices.id, count(invoice_items.invoice_id = invoices.id) as item_count')
      .group('invoices.id')
      .having('count(invoice_items.invoice_id = invoices.id) = 0')
      .pluck(:id)
  end

  def self.delete_only_item_invoices(item_invoices)
    invoice_ids = find_only_item_invoices(item_invoices)
    delete(invoice_ids)
  end
end
