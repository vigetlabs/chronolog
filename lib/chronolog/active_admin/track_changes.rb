module Chronolog
  module ActiveAdmin
    module TrackChanges
      private

      def track_changes
        controller do
          before_action :store_old_state,  only: [:update, :destroy]
          before_action :store_identifier, only: [:destroy]
          after_action  :create_changeset, only: [:create, :update, :destroy]

          private

          def resource_attributes
            clone = resource_class.find(resource.id)

            if clone.respond_to?(:diff_attributes)
              clone.diff_attributes
            else
              Chronolog::DiffRepresentation.new(clone).attributes
            end
          end

          def store_old_state
            @old_state = resource_attributes
          end

          def store_identifier
            @identifier = "#{resource} (#{resource.class.to_s.titleize})"
          end

          def create_changeset
            if resource.errors.none?
              changeset_attrs = {
                admin_user: current_admin_user,
                action:     params[:action],
                identifier: @identifier,
                old_state:  @old_state,
              }

              unless params[:action] == "destroy"
                changeset_attrs.merge!(
                  target:    resource,
                  new_state: resource_attributes
                )
              end

              Chronolog::ChangeTracker.new(changeset_attrs).create_changeset
            end
          end
        end
      end
    end
  end
end
