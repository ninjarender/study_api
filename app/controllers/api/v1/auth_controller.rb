module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!

      def create
        user = User.find_by(email: params[:email])&.authenticate_password(params[:password])

        if user
          render json: UserSerializer.new(user, with_password: true).as_json
        else
          render json: { error: ['Invalid email or password'] }, status: :unauthorized
        end
      end
    end
  end
end
