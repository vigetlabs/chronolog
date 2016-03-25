module Chronolog
  class ChangeTracker
    attr_reader :action,
                :admin_user,
                :target,
                :identifier,
                :old_state,
                :new_state

    def initialize(options)
      @action     = options.fetch(:action)
      @admin_user = options.fetch(:admin_user)
      @target     = options[:target]
      @identifier = options[:identifier] || target_identifier
      @old_state  = options[:old_state] || {}
      @new_state  = options[:new_state] || {}
    end

    def create_changeset
      changeset.save! if changeset
    end

    def changes
      @changes ||= Differ.diff(old_state, new_state)
    end

    def changeset
      @changeset ||= Changeset.create(
        action:     action,
        admin_user: admin_user,
        changeable: target,
        changeset:  changes,
        identifier: identifier
      ) unless changes.empty?
    end

    private

    def target_identifier
      "#{target} (#{target.class.to_s.titleize})"
    end
  end
end
