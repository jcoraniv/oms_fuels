class Vehicle < ApplicationRecord
  belongs_to :vehicle_type
  enum status: { active: 'active', inactive: 'inactive' }, _default: 'active'
end
