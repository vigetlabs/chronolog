require 'rails/generators'
require 'rails/generators/active_record'

module Chronolog
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def install_models
      copy_file 'models/changeset.rb', 'app/models/chronolog/changeset.rb'
    end

    def install_migrations
      migration_template 'migrations/create_chronolog_changesets.rb', 'db/migrate/create_chronolog_changesets.rb'
    end

    def install_initializers
      copy_file 'initializers/chronolog.rb', 'config/initializers/chronolog.rb'
    end

    def install_admin_resource
      copy_file 'admin/changeset.rb', 'app/admin/changeset.rb'
    end

    def install_views
      copy_file 'views/_changeset.html.erb', 'app/views/admin/changesets/_changeset.html.erb'
    end

    def install_helpers
      copy_file 'helpers/chronolog_helper.rb', 'app/helpers/active_admin/chronolog_helper.rb'
    end
  end
end
