class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items

  def self.find_by_name(string, condition='one')
    search = where('name ILIKE ?', "%#{string}%").order(:name)
    condition == 'all' ? search : search.limit(1).first
  end
end
