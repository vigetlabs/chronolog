class User < ActiveRecord::Base
  include Chronolog::Changesets

  belongs_to :organization

  has_many :posts, dependent: :destroy
  has_many :photo_attachments, as: :resource
  has_many :photos, through: :photo_attachments, source: :resource, source_type: 'User'

  validates :name, presence: true

  def to_s
    name
  end
end
