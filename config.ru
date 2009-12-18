#\ -E none -p 9292

# FileUtils.mkdir_p 'log' unless File.exists?('log')
# log = File.new("log/sinatra.log", "a")
# $stdout.reopen(log)
# $stderr.reopen(log)

require 'app'
run Sinatra::Application