begin
  require 'beanstalk-client'

  b = Beanstalk::Pool.new [ 'purple.west.spy.net:11300' ]
  b.use 'westspyxmpp'
  hostname=`hostname`.strip
  b.put "dustin@sallings.org money - started on #{hostname}"
  b.close
rescue
  # Just don't announce
end
