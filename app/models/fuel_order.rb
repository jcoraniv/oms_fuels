class FuelOrder < ApplicationRecord
  belongs_to :gestion
  belongs_to :requester_assignment, class_name: 'Assignment'
  belongs_to :approver_assignment, class_name: 'Assignment', optional: true

  attr_accessor :vehicle_id

  has_many :fuel_order_items, dependent: :destroy
  accepts_nested_attributes_for :fuel_order_items, allow_destroy: true, reject_if: :all_blank

  enum :status, { pending: 'pending', approved: 'approved', completed: 'completed', canceled: 'canceled' }, default: 'pending'

  validates :number, presence: true, uniqueness: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_number, on: :create
  before_save :calculate_total

  private

  def generate_number
    return if number.present?
    
    last_order = FuelOrder.order(id: :desc).first
    next_sequence = last_order ? last_order.id + 1 : 1
    self.number = "OC-#{next_sequence.to_s.rjust(4, '0')}"
  end

  def calculate_total
    self.total = fuel_order_items.sum(&:partial_price)
  end
end
