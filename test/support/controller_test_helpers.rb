module ControllerTestHelpers
  def json_response
    JSON.parse(response.body)
  end

  def sign_in(user)
    token = JsonWebToken.encode(user_id: user.id)
    @request.headers['Authorization'] = "Bearer #{token}"
    @request.headers['Content-Type'] = 'application/json'
  end
end