# disable_rubygems
disable_system_gems

clear_sources
source 'http://gemcutter.org'
source 'http://gems.github.com'

gem 'actionpack',     :require_as => 'action_pack'
gem 'activesupport',  :require_as => 'active_support'
gem 'dm-core'
gem 'dm-types'
gem 'dm-aggregates'
gem 'dm-is-list'
gem 'dm-serializer'
gem 'do_sqlite3'
gem 'haml'
gem 'less'
gem 'RedCloth'
gem 'sinatra'
gem 'stringex'        # dm-types should list this as a dependency

only :test do
  gem 'cucumber'
  gem 'faker'
  gem 'jspec'
  gem 'machinist'
  gem 'rspec',        :require_as => 'spec'
  gem 'webrat'
end