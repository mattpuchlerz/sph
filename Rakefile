require 'net/ssh'
load 'Deploy'

%w[ host username deploy_path repository ].each do |var|
  instance_eval "def #{var}; @#{var} || ( raise 'You must specify @#{var}' ); end"
end

def branch
  @branch ||= 'master'
end

def revision
  @revision ||= 'HEAD'
end

def date_string
  @date_string ||= DateTime.now.strftime '%Y-%m-%d-%H-%M-%S'
end

def ssh_desc str
  puts "\n#{ str }..."
end

def ssh_exec *args
  Net::SSH.start(host, username) do |ssh|
    cmd = args.join ' && '
    puts ssh.exec!(cmd) || 'Done.'
    ssh.loop
  end
end

desc 'Deploy the latest revision of the app'
task :deploy => [ :'deploy:update', :'deploy:bundle_gems', :'deploy:restart' ]
namespace :deploy do
  
  desc 'Bundle gems for the checked out branch'
  task :bundle_gems do
    ssh_desc 'Bundling gems'
    ssh_exec "cd #{ deploy_path }/current/",
             "gem bundle"
  end
  
  desc 'Restart Passenger'
  task :restart do
    ssh_desc 'Restarting Passenger'
    ssh_exec "cd #{ deploy_path }/current/",
             "mkdir -p tmp/",
             "touch tmp/restart.txt"
  end
  
  desc 'Initial setup of your server'
  task :setup => [ :'setup:directories', :'setup:app' ]
  namespace :setup do
    
    desc 'Create the directory structure'
    task :directories do
      ssh_desc 'Creating directory structure'
      ssh_exec "mkdir -p #{ deploy_path }",
               "cd #{ deploy_path }",
               "mkdir -p shared/log",
               "mkdir -p shared/system"
    end
    
    desc 'Create the app by cloning the source from Git'
    task :app do
      ssh_desc 'Cloning the source from Git'
      ssh_exec "cd #{ deploy_path }",
               "git clone #{ repository } current"
    end
    
  end
  
  desc 'Update to the latest source from Git'
  task :update do
    ssh_desc "Updating to the #{ revision } revision"
    ssh_exec "cd #{ deploy_path }/current/",
             "git checkout #{ branch }",
             "git pull",
             "git reset --hard #{ revision }",
             #"git submodule update --init",
             "git branch -f deployed-#{ date_string } #{ revision }",
             "git checkout deployed-#{ date_string }"
  end
  
  # TODO: Cleanup deployment branches
  # $ DEPLOYED=`git branch -l | grep deployed`
  # $ for x in $DEPLOYED; do git branch -d $x; done

end
