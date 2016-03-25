module Chronolog
  module Test
    class Database < ActiveRecord::Migration
      def self.build
        ActiveRecord::Base.establish_connection(
          adapter:  'sqlite3',
          database: ':memory:'
        )

        new.migrate(:up)
      end

      def initialize
        self.verbose = false
      end

      def change
        create_table :admin_users do |t|
          t.string :email,              null: false, default: ""
          t.string :encrypted_password, null: false, default: ""
        end

        add_index :admin_users, :email, unique: true
        
        create_table :chronolog_changesets do |t|
          t.integer :admin_user_id
          t.integer :changeable_id
          t.string  :changeable_type
          t.text    :changeset,       null: false
          t.string  :action,          null: false
          t.string  :identifier,      null: false

          t.foreign_key :admin_users, on_delete: :nullify

          t.timestamps null: false
        end

        add_index :chronolog_changesets, :admin_user_id
        add_index :chronolog_changesets, [:changeable_id, :changeable_type], name: :index_changesets_on_changeable_id_and_type

        create_table :organizations do |t|
          t.string :name, null: false, index: true
        end

        create_table :users do |t|
          t.string  :name, null: false, index: true
          t.integer :organization_id

          t.foreign_key :orgnaizations, on_delete: :nullify
        end

        add_index :users, :organization_id

        create_table :photo_attachments do |t|
          t.integer :photo_id,      null: false, index: true
          t.integer :resource_id,   null: false
          t.string  :resource_type, null: false
        end

        add_index :photo_attachments, [:resource_id, :resource_type]
        add_index :photo_attachments, [:resource_id, :resource_type, :photo_id], unique: true, name: :index_photo_attachments_on_resource_and_photo

        create_table :photos do |t|
          t.string :url, null: false
        end

        add_index :photos, :url, unique: true

        create_table :tags do |t|
          t.integer :post_id, null: false
          t.string  :value,   null: false
          
          t.foreign_key :posts, on_delete: :cascade
        end

        add_index :tags, :post_id
        add_index :tags, [:post_id, :value], unique: true

        create_table :posts do |t|
          t.string  :title,   null: false
          t.text    :body,    null: false
          t.integer :user_id, null: false
          t.date    :published_date

          t.foreign_key :users, on_delete: :cascade
        end

        add_index :posts, :user_id
      end
    end
  end
end
