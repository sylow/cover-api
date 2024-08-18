module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # include JwtMethods
    identified_by :current_user

    def connect
      self.current_user = current_user
    end

    def decoded_token
      token = request.params['token']
      decoded = JWT.decode(token, nil, false).first
    end

    def current_user
      if decoded_token
        User.find_by(id: decoded_token['user_id'])
      end
    end
  end
end
