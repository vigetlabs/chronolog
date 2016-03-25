class CreateChronologChangesets < ActiveRecord::Migration
  def up
    create_table :chronolog_changesets do |t|
      t.integer :admin_user_id
      t.integer :changeable_id
      t.string  :changeable_type
      t.json    :changeset,       null: false
      t.string  :action,          null: false
      t.string  :identifier,      null: false

      t.foreign_key :admin_users, dependent: :nullify

      t.timestamps
    end

    add_index :chronolog_changesets, :admin_user_id
    add_index :chronolog_changesets, [:changeable_id, :changeable_type], name: :index_changesets_on_changeable_id_and_type
  end

  def down
    remove_foreign_key :chronolog_changesets, :admin_users

    remove_index :chronolog_changesets, :admin_user_id
    remove_index :chronolog_changesets, name: :index_changesets_on_changeable_id_and_type

    drop_table :chronolog_changesets
  end
end
