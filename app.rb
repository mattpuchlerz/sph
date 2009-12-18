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
  
  use Rack::Flash
  
  set :root, ROOT
  set :sessions, true
  
  DataMapper.setup :default, "sqlite3://#{ ROOT }/db/#{ Sinatra::Application.environment }.sqlite3"
  DataMapper.auto_upgrade!
  
end



# 
# Routes
# 

get '/' do
  @solutions_in_last_hour = Solution.count :created_at.gte => (Time.now - 3600)
  erb :index
end

post '/' do
  @solution = Solution.new params
  if @solution.save
    flash[:ok] = '<p>Somebody just said &ldquo;solution&rdquo;. I feel for you.</p>'
  else
    flash[:error] = '<p>Couldn&rsquo;t log your &ldquo;solution&rdquo; at this time. Sorry about that.</p>'
  end
  redirect '/'
end
