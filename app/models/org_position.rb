class OrgPosition < ApplicationRecord
  belongs_to :org_structure
  belongs_to :position

  has_many :assignments, dependent: :destroy
  has_many :personals, through: :assignments

  accepts_nested_attributes_for :position
  accepts_nested_attributes_for :assignments, allow_destroy: true, reject_if: :all_blank

  delegate :gestion, to: :org_structure
  delegate :department, to: :org_structure
end
