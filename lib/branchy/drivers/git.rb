module Branchy
  # Drivers for SCMs
  module Drivers
    # A Branchy driver for git
    class Git
      include ::Branchy::CLI

      # Returns the git branch name
      def branch
        exec_or_raise('git symbolic-ref HEAD').sub('refs/heads/', '')
      end

      # Returns true if it's the master/trunk/mainline branch.
      def trunk?
        branch == 'master'
      end

      # Returns true if this git branch has been configured with a branched database
      def enabled?
        exec_or_raise("git config --bool branch.#{branch}.database") == 'true'
      end

      # Enables a database for this git branch
      def enable!
        exec_or_raise("git config --bool branch.#{branch}.database true")
      end

      # Disables a database for this git branch
      def disable!
        exec_or_raise("git config --bool branch.#{branch}.database false")
      end
    end
  end
end
