class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_indexer, only: :index
  before_action :correct_destroyer, only: :destroy

  def index
  end

  def create
    fr = current_user.sent_friend_requests.build(receiver_id: params[:user_id])
    if fr.save
      flash[:info] = "Friend request sent."
    else
      flash[:danger] = "Friend request not sent. It may already exist, or "\
                       "you may have sent a request to a current friend (or "\
                       "yourself)."
    end
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to users_path
    end
  end

  def destroy
    if current_user == @fr.receiver
      flash[:info] = "Friend request ignored."
    else
      flash[:info] = "Friend request canceled."
    end
    @fr.destroy
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to user_friend_requests_path(current_user)
    end
  end

  private

    def correct_indexer
      @user = User.find(params[:user_id])
      unless current_user == @user
        flash[:danger] = "Access denied. Users may only view their own "\
                         "friend requests."
        redirect_to root_url
      end
    end

    def correct_destroyer
      @fr = FriendRequest.find_by(id: params[:id])
      if @fr.nil?
        flash[:danger] = "Request already canceled!"
        begin
          redirect_to :back
        rescue ActionController::RedirectBackError
          redirect_to user_friend_requests_path(current_user)
        end
      elsif current_user != @fr.sender && current_user != @fr.receiver
        flash[:danger] = "Access denied. Users may only ignore or cancel "\
                         "their own friend requests."
        redirect_to root_url
      end
    end
end
