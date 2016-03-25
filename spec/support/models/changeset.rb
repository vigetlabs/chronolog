module Chronolog
  class Changeset < ActiveRecord::Base
    include Chronolog::Model

    serialize :changeset, Hash
  end
end
