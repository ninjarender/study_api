module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: :create
    
      def show
        render json: @current_user
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: UserSerializer.new(@user, with_password: true).as_json, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        @user.destroy
      end
    
      private
  
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
      end
    end
  end
end
