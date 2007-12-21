module ApiHelper

  class AuthException < StandardError
  end

  class IdNameStruct < ActionWebService::Struct
    member :id, :int  
    member :name, :string
  end

  def authenticate(username, password)
    user = User.authenticate(username, password)
    raise AuthException.new("Auth Exception") if user.nil?
    user
  end
  
end
