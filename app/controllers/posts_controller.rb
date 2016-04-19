class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = "Post created."
    else
      flash[:danger] = "Post not created. Content can't be blank."
    end
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end

  private

    def post_params
      params.require(:post).permit(:content, :picture)
    end
end
