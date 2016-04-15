class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @user = current_user
      @profile = @user.profile
      @posts = @user.timeline.paginate(page: params[:page])
      @timeline = true
      @post = @user.posts.build
      render "users/show"
    end
  end
end
