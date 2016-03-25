class Tag < ActiveRecord::Base
  belongs_to :post

  validates :post,
            :value,
            presence: true

  validates :value, uniqueness: { scope: :post_id }

  def to_s
    value
  end

  def diff_attributes
    Chronolog::DiffRepresentation.new(self, ignore: :post_id).attributes
  end
end
