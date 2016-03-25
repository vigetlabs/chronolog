module Chronolog
  module Changesets
    extend ActiveSupport::Concern
 
    included do
      has_many :changesets, as: :changeable, class_name: 'Chronolog::Changeset', dependent: :nullify
   
      def created_by
        changesets.find_by(action: 'create').try(:admin_user)
      end
   
      def last_modified_by
        changesets.recent.where(action: 'update').first.try(:admin_user)
      end
    end
  end
end
