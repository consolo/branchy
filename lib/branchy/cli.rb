require 'open3'

module Branchy
  # Exception for failed CLI commands
  CommandFailed = Class.new(RuntimeError)

  # Shared command line functionality
  module CLI
    protected

    # If command is successful, returns stdout. Otherwise raises a CommandFailed exception.
    def exec_or_raise(command, success_codes = [0])
      stdout, stderr, process_status = self.exec(command)
      if success_codes.include? process_status.exitstatus
        return stdout.gets.to_s.chomp
      else
        raise CommandFailed, "Command `#{command}` failed with status #{process_status.exitstatus}\n#{stderr.gets.to_s.chomp}"
      end
    end

    # Execute the command and return stdout, stderr, and process_status
    def exec(command)
      stdin, stdout, stderr, wait_thread = Open3.popen3(command)
      process_status = wait_thread.value
      return stdout, stderr, process_status
    end
  end
end
