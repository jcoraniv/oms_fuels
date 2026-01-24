class FuelOrder < ApplicationRecord
  belongs_to :gestion
  belongs_to :requester_assignment, class_name: 'Assignment'
  belongs_to :approver_assignment, class_name: 'Assignment', optional: true

  enum :status, { pending: 'pending', approved: 'approved', completed: 'completed', canceled: 'canceled' }, default: 'pending'

  validates :number, presence: true, uniqueness: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_number, on: :create

  private

  def generate_number
    return if number.present?
    
    # Simple logic to generate a correlative number like "OC-0001"
    # This can be improved to be concurrency-safe or scoped by gestion
    last_order = FuelOrder.order(id: :desc).first
    next_sequence = last_order ? last_order.id + 1 : 1
    self.number = "OC-#{next_sequence.to_s.rjust(4, '0')}"
  end
end
