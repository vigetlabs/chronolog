require 'spec_helper'

RSpec.describe Chronolog::InstallGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __FILE__)

  before do
    prepare_destination
    run_generator
  end

  it "generates the changeset model" do
    assert_file 'app/models/chronolog/changeset.rb', /module Chronolog\s+class Changeset < ActiveRecord::Base/
  end

  it "generates the changesets migration" do
    assert_migration 'db/migrate/*_create_chronolog_changesets.rb', /class CreateChronologChangesets < ActiveRecord::Migration/
  end

  it "generates an initializer" do
    assert_file 'config/initializers/chronolog.rb', /ActiveAdmin::ResourceDSL\.send\(:include, Chronolog::ActiveAdmin::TrackChanges\)/
  end

  it "generates the ActiveAdmin resource file for Chronolog::Changeset" do
    assert_file 'app/admin/changeset.rb', /ActiveAdmin\.register Chronolog::Changeset, as: 'Changeset'/
  end

  it "generates the changeset view partial" do
    assert_file 'app/views/admin/changesets/_changeset.html.erb', /<ul class="changeset-list">/
  end

  it "generates the Chronolog helper" do
    assert_file 'app/helpers/active_admin/chronolog_helper.rb', /module ActiveAdmin\s+module ChronologHelper/
  end
end
