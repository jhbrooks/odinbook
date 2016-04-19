class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @posts = @user.posts.paginate(page: params[:page])
    @timeline = false
    @post = @user.posts.build
  end

  def edit
    @profile = @user.profile
  end

  def update
    @profile = @user.profile
    if @profile.update_attributes(profile_params)
      flash[:info] = "Profile updated."
      redirect_to @user
    else
      render :edit
    end
  end

  private
    def profile_params
      params.require(:profile).permit(:city, :state, :country, :time_zone,
                                      :birthday, :gender, :picture)
    end

    # Before actions

    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:danger] = "Access denied. "\
                         "Users may only edit their own profiles."
        redirect_to root_url
      end
    end
end
