module Chronolog
  class Changeset < ActiveRecord::Base
    include Chronolog::Model
  end
end
