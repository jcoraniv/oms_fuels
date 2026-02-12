class FuelOrder < ApplicationRecord
  belongs_to :gestion
  belongs_to :requester_assignment, class_name: 'Assignment'
  belongs_to :approver_assignment, class_name: 'Assignment', optional: true

  attr_accessor :vehicle_id

  has_one_attached :requester_sign
  has_one_attached :approver_sign

  has_many :fuel_order_items, dependent: :destroy
  accepts_nested_attributes_for :fuel_order_items, allow_destroy: true, reject_if: :all_blank

  enum :status, { pending: 'pending', approved: 'approved', completed: 'completed', canceled: 'canceled' }, default: 'pending'

  validates :number, presence: true, uniqueness: { scope: :gestion_id }, on: :update
  validates :approver_assignment_id, presence: true
  validates :vehicle_id, presence: true, unless: :canceled?
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_number, on: :create
  after_save :calculate_total

  def self.ransackable_attributes(auth_object = nil)
    ["number", "status", "total", "gestion_id", "requester_assignment_id", "approver_assignment_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["gestion", "requester_assignment", "approver_assignment", "fuel_order_items"]
  end

  def formatted_number
    number.to_s.rjust(4, '0')
  end

  private

  def generate_number
    return if number.present?
    
    last_order = FuelOrder.where(gestion_id: gestion_id).order(number: :desc).lock('FOR UPDATE').first
    self.number = last_order ? last_order.number + 1 : 1
  end

  def calculate_total
    total_amount = fuel_order_items.reject(&:marked_for_destruction?).sum { |item| item.partial_price || 0 }
    update_column(:total, total_amount) if total != total_amount
  end
end
