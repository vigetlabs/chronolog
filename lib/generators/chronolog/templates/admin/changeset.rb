ActiveAdmin.register Chronolog::Changeset, as: 'Changeset' do
  config.sort_order = 'created_at_desc'

  menu false

  actions :index, :show

  filter :admin_user, label: 'Admin User'
  filter :created_at

  index do
    column :created_at

    column :summary do |changeset|
      change_summary changeset
    end

    column :changes do |changeset|
      link_to 'View Changes', admin_changeset_path(changeset)
    end
  end

  show do
    attributes_table do
      row :message do |changeset|
        change_summary changeset
      end

      row :changed_at do |changeset|
        changeset.created_at.to_s(:summary)
      end

      row :changes do |changeset|
        render 'changeset', changeset: changeset.changeset
      end
    end
  end

  csv do
    column :id

    column :record_changed do |changeset|
      changeset.identifier
    end

    column :action do |changeset|
      changeset.action.capitalize
    end

    column :changed_by do |changeset|
      changeset.admin_user.to_s
    end

    column :changeset
    column :created_at
  end
end
