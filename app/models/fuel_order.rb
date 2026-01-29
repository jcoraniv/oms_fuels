class FuelOrder < ApplicationRecord
  belongs_to :gestion
  belongs_to :requester_assignment, class_name: 'Assignment'
  belongs_to :approver_assignment, class_name: 'Assignment', optional: true

  attr_accessor :vehicle_id

  has_many :fuel_order_items, dependent: :destroy
  accepts_nested_attributes_for :fuel_order_items, allow_destroy: true, reject_if: :all_blank

  enum :status, { pending: 'pending', approved: 'approved', completed: 'completed', canceled: 'canceled' }, default: 'pending'

  validates :number, presence: true, uniqueness: { scope: :gestion_id }
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  before_create :generate_number
  after_save :calculate_total

  def formatted_number
    number.to_s.rjust(4, '0')
  end

  private

  def generate_number
    return if number.present?
    
    FuelOrder.transaction do
      last_order = FuelOrder.where(gestion_id: gestion_id).lock.order(number: :desc).first
      next_sequence = last_order ? last_order.number.to_i + 1 : 1
      self.number = next_sequence.to_s
    end
  end

  def calculate_total
    total_amount = fuel_order_items.reject(&:marked_for_destruction?).sum { |item| item.partial_price || 0 }
    update_column(:total, total_amount) if total != total_amount
  end
end
