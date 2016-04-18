class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:post_id]
      parent = Post.find(params[:post_id])
    elsif params[:comment_id]
      parent = Comment.find(params[:comment_id])
    end

    @reaction = parent.reactions.build(mode: "like", user_id: current_user.id)

    if @reaction.save
      flash[:info] = "#{parent.class} liked."
    else
      flash[:danger] = "#{parent.class} not liked. Perhaps you've already "\
                       "liked it?"
    end

    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end
