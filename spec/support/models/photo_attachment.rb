class PhotoAttachment < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :photo

  validates :resource, :photo, presence: true

  validates :photo_id, uniqueness: { scope: [:resource_id, :resource_type] }
end
