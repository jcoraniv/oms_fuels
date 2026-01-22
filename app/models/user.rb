class User < ApplicationRecord
  has_secure_password

  belongs_to :role
  belongs_to :personal
  has_many :user_gestions, dependent: :destroy
  has_many :gestions, through: :user_gestions

  accepts_nested_attributes_for :personal

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :role_id, presence: true
  validates :personal_id, presence: true

  scope :active, -> { where(active: true) }

  def current_gestion
    user_gestions.find_by(current: true)&.gestion
  end

  def set_current_gestion(gestion_id)
    transaction do
      user_gestions.update_all(current: false)
      user_gestion = user_gestions.find_or_initialize_by(gestion_id: gestion_id)
      user_gestion.current = true
      user_gestion.save!
    end
  end

  def full_name
    personal&.full_name
  end

  def admin?
    role.name == 'Admin'
  end

  def employee?
    role.name == 'Employee'
  end
end
