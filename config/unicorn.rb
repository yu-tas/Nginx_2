require 'fileutils'

preload_app true
timeout 30
worker_processes 4

listen '/tmp/nginx.socket', backlog: 1024

before_fork do |server, worker|
  FileUtils.touch('/tmp/app-initialized')
  
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

