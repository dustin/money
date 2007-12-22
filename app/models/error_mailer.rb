class ErrorMailer < ActionMailer::Base

  def snapshot(exception, trace, session, params, env, sent_on = Time.now)

    # Setting the content-type like this does:
    content_type "text/html" 

    @recipients         = 'dustin@spy.net'
    @from               = 'Money Error Mailer <dustin+rails@spy.net>'
    @subject            = "[Error] exception in #{env['REQUEST_URI']}" 
    @sent_on            = sent_on
    @body["exception"]  = exception
    @body["trace"]      = trace
    @body["session"]    = session
    @body["params"]     = params
    @body["env"]        = env
  end

end
