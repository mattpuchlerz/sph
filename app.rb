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
  property :ip,         IPAddress, :key => true
  property :created_at, DateTime,  :key => true, :default => Time.now

end



# 
# Configuration
#

configure do
  
  use Rack::Flash
  
  enable :raise_errors, :sessions

  set :root, ROOT
  
  DataMapper.setup :default, "sqlite3://#{ ROOT }/db/#{ Sinatra::Application.environment }.sqlite3"
  DataMapper.auto_upgrade!
  
end



# 
# Helpers
# 

helpers do
  
  def sph
    '<acronym title="Solutions Per Hour">SPH</acronym>'
  end
  
end



# 
# Routes
# 

get '/' do
  @worldwide_sph  = Solution.count :created_at.gte => (Time.now - 3600)
  @request_ip_sph = Solution.count :created_at.gte => (Time.now - 3600), :ip => request.ip
  erb :index
end

post '/' do
  @solution = Solution.new :ip => request.ip
  if @solution.save
    flash[:ok] = '<p><strong>There I go again!</strong> Did you hear? I said solution! Spell it with me: S-O-L-U-T-I-O-N!</p>'
  else
    flash[:error] = '<p><strong>I&rsquo;m not feeling so well.</strong> Having trouble saying sol&hellip; solut&hellip; try again later?</p>'
  end
  redirect '/'
end



# 
# Non-Production Routes
# 

unless Sinatra::Application.environment == :production

  get '/:template' do
    erb params[:template].to_sym
  end
        
end
