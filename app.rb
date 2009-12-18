# Note the application's root directory for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

# Add bundled gems to the load path, and require them
require "#{ ROOT }/vendor/gems/environment"
Bundler.require_env



# 
# Models
# 

class Solution
  
  include DataMapper::Resource
  
  property :id,         Serial
  property :email,      String
  property :created_at, DateTime, :key => true, :default => Time.now
  
end



# 
# Configuration
#

configure do
  
  set :root, ROOT
  
  DataMapper.setup :default, "sqlite3://#{ ROOT }/db/#{ Sinatra::Application.environment }.sqlite3"
  DataMapper.auto_upgrade!
  
end



# 
# Routes
# 

get '/' do
  @solutions = Solution.all
  erb :index
end

post '/' do
  @solution = Solution.new params
  @solution.save
  redirect '/'
end
