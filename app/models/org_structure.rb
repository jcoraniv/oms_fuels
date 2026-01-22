class OrgStructure < ApplicationRecord
  belongs_to :gestion
  belongs_to :department
  belongs_to :parent_dept, class_name: 'OrgStructure', optional: true

  has_many :child_depts, class_name: 'OrgStructure', foreign_key: 'parent_dept_id', dependent: :destroy
  has_many :org_positions, dependent: :destroy

  validates :gestion_id, uniqueness: { scope: :department_id, message: "This department is already part of the organizational structure for this gestion." }
end
