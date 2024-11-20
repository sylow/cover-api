require "test_helper"

class UserTokenTest < ActiveSupport::TestCase
  def setup
    @user = Fabricate(:user)
    @token = Fabricate(:user_token,
      user: @user,
      kind: 'password_reset_token',
    )
  end

  test "valid token" do
    assert @token.valid?
  end

  test "associations" do
    assert_respond_to @token, :user
    assert @token.user == @user
  end

  test "validations" do
    # Test presence validations
    @token.token = nil
    assert_not @token.valid?
    assert_includes @token.errors[:token], "can't be blank"

    @token.token = SecureRandom.hex(10)
    @token.kind = nil
    assert_not @token.valid?
    assert_includes @token.errors[:kind], "can't be blank"

    @token.kind = 'password_reset_token'
    @token.expires_at = nil
    assert_not @token.valid?
    assert_includes @token.errors[:expires_at], "can't be blank"

    # Test kind inclusion validation
    @token.expires_at = 2.hours.from_now
    @token.kind = 'invalid_kind'
    assert_not @token.valid?
    assert_includes @token.errors[:kind], "is not included in the list"

    # Test valid kinds
    @token.kind = 'password_reset_token'
    assert @token.valid?

    @token.kind = 'email_verification_token'
    assert @token.valid?
  end

  test "token uniqueness" do
    duplicate_token = @token.dup
    assert_not duplicate_token.valid?
    assert_includes duplicate_token.errors[:token], "has already been taken"
  end

  test "user association required" do
    @token.user = nil
    assert_not @token.valid?
    assert_includes @token.errors[:user], "must exist"
  end

  test "valid scope" do
    # Create expired and valid tokens
    expired_token = Fabricate(:user_token,
      user: @user,
      expires_at: 1.hour.ago,
      token: SecureRandom.hex(10)
    )
    valid_token = Fabricate(:user_token,
      user: @user,
      expires_at: 1.hour.from_now,
      token: SecureRandom.hex(10)
    )

    valid_tokens = UserToken.valid
    assert_includes valid_tokens, valid_token
    assert_not_includes valid_tokens, expired_token
  end

  test "is_valid? method" do
    @token.expires_at = 1.hour.ago
    assert_not @token.is_valid?

    @token.expires_at = 1.hour.from_now
    assert @token.is_valid?
  end

  test "kind scopes" do
    Fabricate(:user_token,
      user: @user,
      kind: 'password_reset_token',
      token: SecureRandom.hex(10)
    )
    Fabricate(:user_token,
      user: @user,
      kind: 'email_verification_token',
      token: SecureRandom.hex(10)
    )

    assert_equal 2, UserToken.where(kind: 'password_reset_token').count
    assert_equal 1, UserToken.where(kind: 'email_verification_token').count
  end

  # Clean up test data
  def teardown
    UserToken.delete_all
    User.delete_all
  end
end