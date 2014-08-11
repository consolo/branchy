module Branchy
  # Drivers for SCMs
  module Drivers
    # A Branchy driver for git
    class Git
      extend ::Branchy::CLI

      # Returns the git branch name
      def self.branch
        exec_or_raise('git symbolic-ref HEAD').sub('refs/heads/', '')
      end

      # Returns true if it's the master/trunk/mainline branch.
      def self.trunk?
        branch == 'master'
      end

      # Returns true if this git branch has been configured with a branched database
      def self.enabled?
        exec_or_raise("git config --bool branch.#{branch}.database") == 'true'
      end

      # Enables a database for this git branch
      def self.enable!
        exec_or_raise("git config --bool branch.#{branch}.database true")
      end

      # Disables a database for this git branch
      def self.disable!
        exec_or_raise("git config --bool branch.#{branch}.database false")
      end
    end
  end
end
