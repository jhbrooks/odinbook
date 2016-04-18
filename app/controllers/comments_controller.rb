class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:post_id]
      parent = Post.find(params[:post_id])
    end

    @comment = parent.comments.build(content: params[:comment][:content],
                                     user_id: current_user.id)

    if @comment.save
      flash[:info] = "Comment created."
    else
      flash[:danger] = "Comment not created. Content can't be blank."
    end

    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end

  # def create
  #   @post = Post.find(params[:post_id])
  #   @comment = @post.comments.build(content: params[:comment][:content],
  #                                   user_id: current_user.id)
  #   if @comment.save
  #     flash[:info] = "Comment created."
  #   else
  #     flash[:danger] = "Comment not created. Content can't be blank."
  #   end
  #   begin
  #     redirect_to :back
  #   rescue ActionController::RedirectBackError
  #     redirect_to root_path
  #   end
  # end
end
