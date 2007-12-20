module ApiHelper

  class IdNameStruct < ActionWebService::Struct
    member :id, :int  
    member :name, :string
  end

  def authenticate(username, password)
    user = User.authenticate(username, password)
    raise "Auth Exception" if user.nil?
    user
  end
  
end
