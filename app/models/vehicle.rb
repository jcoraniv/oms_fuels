class Vehicle < ApplicationRecord
  belongs_to :vehicle_type
  
  enum :status, { active: 'active', inactive: 'inactive' }, default: :active
  
  validates :plate, presence: true
end
