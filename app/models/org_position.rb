class OrgPosition < ApplicationRecord
  belongs_to :org_structure
  belongs_to :position
  belongs_to :reports_to_position, class_name: 'OrgPosition', optional: true

  has_many :direct_reports, class_name: 'OrgPosition', foreign_key: 'reports_to_position_id', dependent: :nullify
  has_many :assignments, dependent: :destroy
  has_many :personals, through: :assignments

  accepts_nested_attributes_for :position
  accepts_nested_attributes_for :assignments, allow_destroy: true, reject_if: :all_blank

  delegate :gestion, to: :org_structure
  delegate :department, to: :org_structure
end
