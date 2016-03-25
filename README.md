# Chronolog

A library that adds diff-powered change tracking to Rails projects with ActiveAdmin + Devise.

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/chronolog`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Dependencies

* Ruby 2.0+
* Rails 4.2+
* ActiveAdmin 1.0.0pre2
* Devise 3.5+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chronolog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chronolog

Then install the gem to your Rails project via:

    $ rails g chronolog:install

This will create the necessary models, migrations, and initializers for Chronolog.

## Usage

To take advantage of Chronolog, just add `track_changes` inside the register blocks for the ActiveAdmin resources you'd like to track:
```ruby
ActiveAdmin.register Post do
  track_changes
end
```

We recommend adding the following to your dashboard:
```ruby
# TODO
```

To query the admin user that either created or last modified a record, include `Chronolog::Changesets` in the model definition:
```ruby
class Post < ActiveRecord::Base
  include Chronolog::Changesets
end
```

This allows you to call the following methods:
```ruby
Post.first.created_by       #=> #<AdminUser>
Post.first.last_modified_by #=> #<AdminUser>
```

## Customizations

### Diff Attributes

Probably the most important model-level customization involves defining `diff_attributes`.  Chronolog has a sensible default for determining what attributes and associations to diff when tracking changes; however, there are definitely cases where you'll want to modify the set of attributes/associations.

Here's an example:
```ruby
# TODO Example
```

### Databases without the JSON Column Type

Chronolog's migration is generated (via `rails g chronolog:install`) with Postgres in mind, as it uses the `json` column type.  If you're using a database that does not support the `json` type, change the following line from `db/migrate/*create_chronolog_changesets.rb` (* represents an auto-generated timestamp):
```ruby
t.json :changeset, null: false
```
To:
```ruby
t.text :changeset, null: false
```

You'll also want to add the following line to `app/models/chronolog/changeset.rb`:
```ruby
serialize :changeset, Hash
```

### ActiveAdmin Dashboard

The dashboard in ActiveAdmin is a great place to display recent changes.  Drop something like this inside the `content` block:
```ruby
panel 'Activity Log' do
  header_action link_to 'View All', [:admin, :changesets]

  table_for Chronolog::Changeset.recent.limit(10) do
    column 'Date' do |changeset|
      changeset.created_at.to_date
    end

    column 'Time' do |changeset|
      changeset.created_at.strftime("%I:%M %P")
    end

    column 'Message' do |changeset|
      change_summary changeset
    end

    column 'Changes' do |changeset|
      link_to 'View Changes', admin_changeset_path(changeset)
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vigetlabs/chronolog.
