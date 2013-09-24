APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
require 'bundler/setup'

worker_processes 4 #WORKER_PROCESSES
working_directory APP_ROOT

timeout 30
preload_app true

listen 5555, :tcp_nopush => true  #PORT_NUMBER
listen APP_ROOT + "/tmp/sockets/unicorn.sock", :backlog => 64
pid APP_ROOT + "/tmp/pids/unicorn.pid"

stderr_path "/var/log/unicorn/unicorn.stderr.log"
stdout_path "/var/log/unicorn/unicorn.stdout.log"

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
  old_pid = APP_ROOT + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Old master alerady dead"
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
