class Photo < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true
end
