module Chronolog
  module Model
    extend ActiveSupport::Concern

    ACTIONS = %w(
      create
      update
      destroy
    )

    included do
      belongs_to :changeable, polymorphic: true
      belongs_to :admin_user

      validates :changeset, :identifier, presence: true

      validates :action, inclusion: { in: Chronolog::Model::ACTIONS }

      scope :recent, -> { order(created_at: :desc) }
      scope :reverse_chron, -> { order(created_at: :desc) }

      def self.table_name_prefix
        'chronolog_'
      end
    end
  end
end
