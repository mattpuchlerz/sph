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
  property :email,      String,   :key => true
  property :created_at, DateTime, :key => true
  
end



# 
# Configuration
#

configure do
  
  use_in_file_templates!
  set :root, ROOT
  
  DataMapper.setup :default, "sqlite3://#{ ROOT }/db/#{ Sinatra::Application.environment }.sqlite3"
  DataMapper.auto_migrate!
  
end



# 
# Helpers
# 

helpers do
  
  def mtime public_file
    path = Sinatra::Application.public + public_file
    "#{ public_file }?#{ File.mtime(path).to_i.to_s }" rescue public_file
  end
  
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
  @solution_created = @solution.save
  erb :solutions_create
end



__END__



@@ layout

<!DOCTYPE html>
<html>
  
  <head>
    <title>Soutions Per Hour</title>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type">
    <meta content="width = device-width" name="viewport">
    <!--[if IE]>
      <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
    <![endif]-->
    <!-- <link href="/stylesheets/global.css" rel="stylesheet" type="text/css"> -->
    <!-- <link href="/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css"> -->
    <!-- <link href="/stylesheets/iphone.css" media="only screen and (max-device-width: 480px)" rel="stylesheet" type="text/css"> -->
    <!-- <link href="/images/favicon.ico" rel="shortcut icon" type="image/x-icon"> -->
  </head>
  
  <body>
    
    <section id="page_container">
      
      <header id="page_header">
        <h1 id="page_title">Solutions Per Hour</h1>
      </header>
    
      <section id="page_content">
        <%= yield %>
      </section>
    
    </section>
    
  </body>
</html>



@@ index 

<%= @solutions.inspect %>



@@ solutions_create

<% if @solutions_created %>
<p>Somebody just said &lsquo;solution&rsquo;. I feel for you.</p>
<% else %>
<p>Couldn&rsquo;t log your &lsquo;solution&rsquo; at this time. Sorry about that.</p>
<% end %>