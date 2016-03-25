module ActiveAdmin
  module ChronologHelper
    def change_summary(changeset)
      target = if changeset.changeable.present?
        link_to changeset.identifier, [:admin, changeset.changeable]
      else
        changeset.identifier
      end

      admin_user = if changeset.admin_user.present?
        link_to changeset.admin_user, [:admin, changeset.admin_user]
      else
        'Deleted User'
      end

      action = changeset.action.gsub(/e$/, '')

      "#{target} was #{action}ed by #{admin_user}".html_safe
    end
  end
end
