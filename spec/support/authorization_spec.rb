module AuthorizationHelper
  def sign_in(user_param)
    post "/api/v1/auth", params: { "email": user_param[:email], "password": user_param[:password], "password_confirmation": user_param[:password] }
    response.headers.slice('client', 'uid', 'access-token')
  end
end