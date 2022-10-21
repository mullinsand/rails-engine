class Invoice < ApplicationRecord
  validates_presence_of :status
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.find_only_item_invoices(item_invoices)
    left_joins(:invoice_items)
      .where('invoices.id IN (?) AND invoice_items.invoice_id IS NULL', item_invoices)
  end

  def self.delete_only_item_invoices(item_invoices)
    only_item_invoices = find_only_item_invoices(item_invoices)
    delete(only_item_invoices)
  end
end
