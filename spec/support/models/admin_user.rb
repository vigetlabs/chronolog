class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, :validatable
end
