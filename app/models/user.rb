class User < ApplicationRecord
  include SoftDeletable
  
  has_secure_password
  has_one_attached :sign_image

  belongs_to :role
  belongs_to :personal
  has_many :user_gestions, dependent: :destroy
  has_many :gestions, through: :user_gestions
  has_many :notification_reads, dependent: :destroy
  has_many :push_subscriptions, dependent: :destroy

  accepts_nested_attributes_for :personal

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :role_id, presence: true
  validates :personal_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["email", "role_id", "personal_id", "status", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["role", "personal", "user_gestions", "gestions"]
  end

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

  def operation?
    role.name == 'Operation'
  end
end
