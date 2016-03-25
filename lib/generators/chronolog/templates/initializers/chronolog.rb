# Adds `track_changes` to ActiveAdmin DSL
ActiveAdmin::ResourceDSL.send(:include, Chronolog::ActiveAdmin::TrackChanges)
