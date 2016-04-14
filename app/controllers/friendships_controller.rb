class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_destroyer, only: :destroy

  def index
    @user = User.find(params[:user_id])
    @friends = @user.friends.paginate(page: params[:page])
  end

  def create
    # Create one side of the friendship
    active_f = current_user.friendships
                           .build(passive_friend_id: params[:user_id])
    # Create other side of the friendship
    passive_f = User.find(params[:user_id])
                    .friendships.build(passive_friend_id: current_user.id)
    if active_f.save && passive_f.save
      flash[:info] = "Friendship formed."
      # Destroy relevant active friend request if it exists
      if !(afr = FriendRequest.where(sender_id: active_f.active_friend_id,
                                     receiver_id: active_f.passive_friend_id)
                              .first).nil?
        afr.destroy
      end
      # Destroy relevant passive friend request if it exists
      if !(pfr = FriendRequest.where(sender_id: passive_f.active_friend_id,
                                     receiver_id: passive_f.passive_friend_id)
                              .first).nil?
        pfr.destroy
      end
    else
      flash[:danger] = "Friendship not formed. Perhaps it already exists?"
    end
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to user_friend_requests_path(current_user)
    end
  end

  def destroy
    flash[:info] = "Friendship ended."
    other_f = Friendship.where(active_friend_id: @f.passive_friend_id,
                               passive_friend_id: @f.active_friend_id).first
    other_f.destroy unless other_f.nil?
    @f.destroy
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to user_friendships_path(current_user)
    end
  end

  private

    def correct_destroyer
      @f = Friendship.find_by(id: params[:id])
      if @f.nil?
        flash[:danger] = "Friendship already ended!"
        begin
          redirect_to :back
        rescue ActionController::RedirectBackError
          redirect_to user_friendships_path(current_user)
        end
      elsif current_user != @f.active_friend && current_user != @f.passive_friend
        flash[:danger] = "Access denied. Users may only end their own "\
                         "friendships."
        redirect_to root_url
      end
    end
end
