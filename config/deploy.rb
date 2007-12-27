set :application, "money"
set :repository,  "http://hg.west.spy.net/hg/web/money/"
set :runner, 'www'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/data/web/rails/#{application}"

set :scm, :mercurial

role :app, "basket.west.spy.net"
role :web, "basket.west.spy.net"
role :db,  "basket.west.spy.net", :primary => true

desc "Starting happens via lighttpd.  Just need to stop here."
deploy.task :start do
  deploy.stop
end
desc "Starting happens via lighttpd.  Just need to stop here."
deploy.task :restart do
  deploy.stop
end
