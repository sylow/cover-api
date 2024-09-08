module JwtMethods
  extend ActiveSupport::Concern
  included do
    before_action :authenticate
  end
  
  def decoded_token
    return nil unless header = request.headers['Authorization']

    if header
      identifier = header.split(' ').first
      token = header.split(' ').last
    end
    return nil if identifier != 'Bearer' || !token

    decoded = JsonWebToken.decode(token)
  end

  def current_user
    if decoded_token
      @current_user ||= User.find_by(id: decoded_token['user_id'])
    end
  end

  def authenticate
    unless !!current_user
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end
end