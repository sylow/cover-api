# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = Fabricate(:user)
  end

  test "should be valid" do
    assert @user.valid?
  end

  # Validation tests
  test "should require email" do
    @user.email = nil
    refute @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "should require valid email format" do
    @user.email = "invalid_email"
    refute @user.valid?
    assert_includes @user.errors[:email], "is not a valid email address"
  end

  test "should require unique email" do
    duplicate_user = @user.dup
    @user.save
    refute duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "should require password" do
    @user.password = nil
    refute @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "should require minimum password length" do
    @user.password = @user.password_confirmation = "short"
    refute @user.valid?
    assert_includes @user.errors[:password], "is too short (minimum is 8 characters)"
  end

  test "should have many tokens" do
    assert_respond_to @user, :user_tokens
  end

  test "should generate password reset token" do
    assert_difference -> { @user.password_reset_tokens.count } do
      outcome = Tokens::Generate.run(
        email: @user.email,
        kind: 'password_reset_token'
      )
      assert outcome.valid?
      assert_not_nil outcome.result
      assert_equal @user, outcome.result.user
      assert_not_nil outcome.result.token
      assert_not_nil outcome.result.expires_at
    end
  end

  test "should generate email verification token" do
    assert_difference -> { @user.email_verification_tokens.count } do
      outcome = Tokens::Generate.run(
        email: @user.email,
        kind: 'email_verification_token'
      )
      assert outcome.valid?
      assert_not_nil outcome.result
      assert_equal @user, outcome.result.user
      assert_not_nil outcome.result.token
      assert_not_nil outcome.result.expires_at
    end
  end

  test "should delete previous tokens when generating new one" do
    # First generate a token
    first_outcome = Tokens::Generate.run(
      email: @user.email,
      kind: 'password_reset_token'
    )
    first_token = first_outcome.result

    # Then generate another token
    assert_difference -> { @user.password_reset_tokens.count }, 0 do
      second_outcome = Tokens::Generate.run(
        email: @user.email,
        kind: 'password_reset_token'
      )
      assert second_outcome.valid?
      refute_equal first_token.token, second_outcome.result.token
    end
  end

  test "should fail to generate token for non-existent user" do
    outcome = Tokens::Generate.run(
      email: 'nonexistent@example.com',
      kind: 'password_reset_token'
    )
    refute outcome.valid?
    assert_includes outcome.errors.full_messages, "User not found"
  end

  # Email verification tests
  test "should verify email with valid token" do
    # Generate a verification token first
    token_outcome = Tokens::Generate.run(
      email: @user.email,
      kind: 'email_verification_token'
    )
    token = token_outcome.result

    # Verify the email
    outcome = Users::VerifyEmail.run(token: token.token)
    assert outcome.valid?
    assert outcome.result.email_confirmed
  end

  test "should not verify email with invalid token" do
    outcome = Users::VerifyEmail.run(token: 'invalid_token')
    refute outcome.valid?
    assert_includes outcome.errors.full_messages, "Token is invalid"
  end

  test "should not verify already verified email" do
    # Generate a verification token first
    token_outcome = Tokens::Generate.run(
      email: @user.email,
      kind: 'email_verification_token'
    )
    token = token_outcome.result

    # Update user to be already verified
    @user.update_column(:email_confirmed, true)
    
    outcome = Users::VerifyEmail.run(token: token.token)
    refute outcome.valid?
    assert_includes outcome.errors.full_messages, "User has already verified email address"
  end

  # Credit management tests
  test "should initialize with zero credits" do
    user = Fabricate(:user)
    assert_equal 0, user.credits
  end

  test "should update credits through purchase" do
    package = Fabricate(:package, credits: 10, price_cents: 1000)
    initial_credits = @user.reload.credits

    outcome = Purchases::Paid.run(
      id: @user.id,
      price_cents: package.price_cents,
      enable_notifications: false
    )
    assert outcome.valid?

    assert_equal initial_credits + package.credits, @user.reload.credits
  end

  test "should create credit transaction on purchase" do
    package = Fabricate(:package, credits: 10, price_cents: 1000)

    assert_difference -> { @user.credit_transactions.count } do
      Purchases::Paid.run(
        id: @user.id,
        price_cents: package.price_cents,
        enable_notifications: false
      )
    end
  end

  test "should fail to update credits for non-existent user" do
    outcome = Purchases::Paid.run(
      id: -1,
      price_cents: 1000,
      enable_notifications: false
    )
    refute outcome.valid?
    assert_includes outcome.errors.full_messages, "User not found"
  end

  # Scope tests
  test "confirmed scope returns only confirmed users" do
    confirmed_user = Fabricate(:verified_user)
    unconfirmed_user = Fabricate(:unverified_user)

    assert_includes User.confirmed, confirmed_user
    refute_includes User.confirmed, unconfirmed_user
  end

  test "unconfirmed scope returns only unconfirmed users" do
    confirmed_user = Fabricate(:verified_user)
    unconfirmed_user = Fabricate(:unverified_user)

    assert_includes User.unconfirmed, unconfirmed_user
    refute_includes User.unconfirmed, confirmed_user
  end
end