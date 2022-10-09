module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[update destroy]
    
      # GET /posts
      def index
        @posts = Post.all
    
        render json: @posts
      end
    
      # GET /posts/1
      def show
        @post = Post.find(params[:id])
    
        render json: @post
      end
    
      # POST /posts
      def create
        @post = @current_user.posts.new(post_params)
    
        if @post.save
          render json: @post, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /posts/1
      def update
        if @post.update(post_params)
          render json: @post
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /posts/1
      def destroy
        @post.destroy
      end
    
      private
    
      def set_post
        @post = @current_user.posts.find(params[:id])
      end
    
      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end


