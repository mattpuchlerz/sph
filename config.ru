#\ -E none -p 9292

# require 'vendor/gems/gems/sinatra-0.9.4/lib/sinatra'
#  
# Sinatra::Application.default_options.merge!(
#   :raise_errors => true,
#   :run          => false
# )

log = File.new 'log/sinatra.log', 'a'
STDOUT.reopen log
STDERR.reopen log

require 'app'
run Sinatra::Application