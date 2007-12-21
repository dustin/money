module ApiHelper

  class AuthorizationException < StandardError
  end

  class IdNameStruct < ActionWebService::Struct
    member :id, :int  
    member :name, :string
  end

  def authenticate(username, password)
    user = User.authenticate(username, password)
    raise AuthorizationException.new("Auth Exception") if user.nil?
    user
  end
  
end
