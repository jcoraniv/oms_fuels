module SoftDeletable
  extend ActiveSupport::Concern

  included do
    enum :status, { active: 0, deleted: 1 }, default: :active
    scope :not_deleted, -> { where.not(status: :deleted) }
    
    def soft_delete
      update(status: :deleted)
    end

    def can_hard_delete?
      self.class.reflect_on_all_associations(:has_many).none? do |assoc|
        next if assoc.options[:dependent] == :destroy
        send(assoc.name).exists?
      end
    end
  end
end
