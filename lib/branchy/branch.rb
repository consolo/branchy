##
# A library for interacting with branched database. I.E. each of your feature branches may
# have its own database to keep schema changes seperated until each is merged into the 
# mainline.
#
# Supported SCMs:
# - git
#
# Example:
#  -> Branchy.git.db('my_project_development')
#  -> "my_project_development_branch_name"
#
# Example with optional branching enabled:
#  -> Branchy.git.db_if_enabled('my_project_development')
#  -> "my_project_development_branch_name"
#
# Example with optional branching disabled:
#  -> Branchy.git.db_if_enabled('my_project_development')
#  -> "my_project_development"
#
# To enable or disable branched databases in a branch, check out your branch and run:
#  $ branchy --enable|--disable
#
module Branchy
  # Returns a new Branchy object initialized for use with git
  def self.git
    Branch.new(Drivers::Git)
  end

  # A class for getting a branch's database name
  class Branch
    # The SCM driver
    attr_reader :scm

    # Initializes a new Branchy with the specified SCM driver
    def initialize(driver)
      @scm = driver
    end

    # Returns the name of the current branch
    def name
      scm.branch
    end

    # Returns prefix + branch name (e.g. "my_project_development_my_branch"), replacing any db name
    # unfriendly characthers with _.
    # If it's the master/trunk/mainline branch only the prefix is returned.
    def database(prefix)
      db_name = scm.trunk? ? prefix : "#{prefix}_#{name}"
      db_name.gsub(/[^A-Za-z0-9_]+/, '_')
    end

    alias_method :db, :database

    # Returns the prefix + branch name, but *only* if branched db has been enabled for this branch.
    # Otherwise it just returns the prefix.
    def database_if_enabled(prefix)
      scm.enabled? ? database(prefix) : prefix
    end

    alias_method :db_if_enabled, :database_if_enabled

    # Enable a branched database for this branch
    def enable!
      scm.enable!
    end

    # Disable a branched database for this branch
    def disable!
      scm.disable!
    end
  end
end
