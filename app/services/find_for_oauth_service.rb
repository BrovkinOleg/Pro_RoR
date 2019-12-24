class FindForOauthService
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    user = User.find_by(email: email) || User.find_by_auth(auth)
    user ||= User.random_user!(email)
    user.authorizations.create!(provider: auth.provider, uid: auth.uid) unless User.find_by_auth(auth)
    user
  end
end
