class Assignment < ApplicationRecord
  include SoftDeletable
  
  belongs_to :personal
  belongs_to :org_position

  validates :personal_id, uniqueness: { scope: [:org_position_id, :end_date], message: "This personal is already assigned to this position for the given period." }
  validate :end_date_after_start_date

  scope :current, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.current, Date.current) }

  delegate :gestion, to: :org_position
  delegate :department, to: :org_position
  delegate :position, to: :org_position

  def self.ransackable_attributes(auth_object = nil)
    ["personal_id", "org_position_id", "start_date", "end_date", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["personal", "org_position"]
  end

  private

  def end_date_after_start_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
