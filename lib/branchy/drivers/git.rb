module Branchy
  # Drivers for SCMs
  module Drivers
    # A Branchy driver for git
    class Git
      extend ::Branchy::CLI

      # Returns the git branch or tag name
      def self.branch
        branch_name || tag_name
      end

      # Returns true if it's the master/trunk/mainline branch.
      def self.trunk?
        branch == 'master'
      end

      # Returns true if this git branch has been configured with a branched database
      def self.enabled?
        exec_or_raise("git config --bool branch.#{branch}.database", [0,1]) == 'true'
      end

      # Enables a database for this git branch
      def self.enable!
        exec_or_raise("git config --bool branch.#{branch}.database true")
      end

      # Disables a database for this git branch
      def self.disable!
        exec_or_raise("git config --bool branch.#{branch}.database false")
      end

      private

      def self.branch_name
        name = exec_or_raise('git rev-parse --abbrev-ref HEAD')
        name == 'HEAD'.freeze ? nil : name
      end

      def self.tag_name
        log = exec_or_raise("git reflog show --decorate -1")
        match = log.match(/, tag: ([^,]+), /)
        match ? match.captures[0] : nil
      end
    end
  end
end
