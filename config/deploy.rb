set :application, "money"
set :repository,  "http://hg.west.spy.net/hg/web/money/"
set :runner, 'www'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/data/web/rails/cap/#{application}"

set :scm, :mercurial

role :app, "basket.west.spy.net"
role :web, "basket.west.spy.net"
role :db,  "basket.west.spy.net", :primary => true

desc "Starting happens via lighttpd"
deploy.task :start do
  deploy.restart
end
# deploy.task :stop do
#   pids=[]
#   run "ps axww | egrep 'web.*rails.*money.*dispatch.fcgi' | grep -v grep | awk '{print $1}' " do |ch, st, data|
#     logger.info "Data:  #{data}"
#   end
# end
