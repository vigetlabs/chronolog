class Post < ActiveRecord::Base
  include Chronolog::Changesets

  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_many :tags, dependent: :destroy
  has_many :photo_attachments, as: :resource
  has_many :photos, through: :photo_attachments, source: :photo

  validates :author,
            :title,
            :body,
            presence: true

  def to_s
    title
  end
end
