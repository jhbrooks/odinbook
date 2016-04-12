class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :user_time_zone, :if => :current_user

  private

    # Around actions

    def user_time_zone(&block)
      if !current_user.profile.time_zone.blank?
        Time.use_zone(current_user.profile.time_zone, &block)
      else
        Time.use_zone(Time.zone_default, &block)
      end
    end
end
