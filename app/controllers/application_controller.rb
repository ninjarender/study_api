class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    @current_user = User.find_by(password_digest: token)

    no_auth unless @current_user
  end

  def token
    request.headers['Authorization']&.gsub('Bearer ', '')
  end

  def no_auth
    render json: { error: ['no user'] }, status: :unauthorized
  end
end
