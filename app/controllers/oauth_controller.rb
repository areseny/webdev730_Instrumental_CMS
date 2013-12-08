class OauthController < ApplicationController

  # GET /auth/:provider/callback
  def callback
    @provider = AuthProvider.find_by_key!(params[:provider])
    token = omniauth[:credentials][:refresh_token] || omniauth[:credentials][:token]
    user_name = omniauth[:info][:name] || omniauth[:info][:nickname]
    user_id = omniauth[:uid]
    @provider.update_attributes!(token: token, user_id: user_id, user_name: user_name)
    render inline: "Token: #{token}", layout: false
  end

  # GET /auth/failure
  def failure
    render inline: "OAuth 2.0 failure", layout: false
  end

  private

  def omniauth
    env['omniauth.auth']
  end

end
