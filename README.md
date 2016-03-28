# Chronolog

A library that adds diff-powered change tracking to Rails projects with ActiveAdmin + Devise.

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

This will create the following files:

* Changeset model (`app/models/chronolog/changeset.rb`)
* Changeset migration (`db/migrate/*_create_chronolog_changesets.rb`)
* Chronolog initializer (`config/initializers/chronolog.rb`)
* ActiveAdmin Changeset resource (`app/admin/changeset.rb`)
* Changeset view partial for ActiveAdmin (`app/views/admin/changesets/_changeset.html.erb`)
* Chronolog admin helper (`app/helpers/active_admin/chronolog_helper.rb`)

## Usage

To take advantage of Chronolog, just add `track_changes` inside the register blocks for the ActiveAdmin resources you'd like to track:
```ruby
ActiveAdmin.register Post do
  track_changes
end
```

Any time a resource with `track_changes` is created, updated, or deleted, Chronolog will generate a `Chronolog::Changeset` record.  Each of these changesets captures the following information:
```ruby
changeset = Chronolog::Changeset.first

changeset.changeable # Returns the record changed unless it has been deleted
changeset.identifier # Always returns a string capturing the object's #to_s and class type at the time of the change
changeset.action     # Returns the change action -- either create, update, or destroy
changeset.changeset  # Returns a hash that captures diff'd attributes/associations/methods and their previous and current values
changeset.admin_user # Returns the AdminUser that made the change unless it has been deleted
changeset.created_at # Timestamp for when the change occurred
```

It's recommended that any resource you include `track_changes` on should have a `#to_s` implementation as it's used to generate an identifier string for the record and model-type on any changeset.  Without `#to_s`, you'll get a Ruby object pointer in the changeset identifier:
```ruby
#<SomeClass:0x007fcfdc650640> (Some Class)
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

Probably the most important model-level customization involves defining `diff_attributes`.  Chronolog has a sensible default for determining what attributes and associations to diff when tracking changes:

* Ignore `id`, `created_at`, and `updated_at` attributes
* Include any `belongs_to` dependencies

These defaults won't work for every case.  Chronolog provides an interface for overriding what attributes, associations, and methods are evaluated when generating a changeset.  Here's an example demonstrating the three options (ignored attributes, included associations, and methods to diff):
```ruby
class Post < ActiveRecord::Base
  has_many :tags

  validates :title, :body, :published_date, presence: true

  def to_s
    "#{title} (Published on #{published_date.strftime('%A %B %e, %Y')})"
  end

  def diff_attributes
    Chronolog::DiffRepresentation.new(self,
      ignore:  %i(published_date),
      include: %i(tags),
      methods: $i(to_s)
    )
  end
end
```

This would result in the following:

* Exclude `published_date` from the diff
* Include a post's associated tags in its diff (will use `Tag#diff_attributes` if defined, otherwise it will use Chronolog's default)
* Include the post's `#to_s` in the changeset

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
