require "rails"
require "chronolog/version"
require "generators/chronolog/install_generator"

module Chronolog
  autoload :ActiveAdmin,        'chronolog/active_admin'
  autoload :ChangeTracker,      'chronolog/change_tracker'
  autoload :Changesets,         'chronolog/changesets'
  autoload :DiffRepresentation, 'chronolog/diff_representation'
  autoload :Differ,             'chronolog/differ'
  autoload :Model,              'chronolog/model'
end
