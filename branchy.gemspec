require File.join(File.dirname(__FILE__), 'lib', 'branchy', 'version')

Gem::Specification.new do |s|
  s.name = 'branchy'
  s.version = Branchy::VERSION
  s.licenses = ['MIT']
  s.summary = "Branched database helpers"
  s.description = "Use a different database for each of your branches!"
  s.date = '2015-07-10'
  s.authors = ['Andrew Coleman', 'Jordan Hollinger']
  s.email = 'jordan@jordanhollinger.com'
  s.homepage = 'http://github.com/consolo/branchy'
  s.require_paths = ['lib']
  s.files = [Dir.glob('lib/**/*'), 'README.rdoc', 'LICENSE'].flatten
  s.executables << 'branchy'
end
