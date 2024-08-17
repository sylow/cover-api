class JsonWebToken
  SECRET_KEY_BASE = ENV['SECRET_KEY_BASE']

  def self.encode(payload, exp = 72.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY_BASE)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
    HashWithIndifferentAccess.new decoded
  end
end