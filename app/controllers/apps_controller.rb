class AppsController < ApplicationController
  def following
    user = User.find_by_fb_id(params[:user_id])
    app = App.find_by_google_id(params[:app_id]) || App.sync(params[:app_id])
    if user.nil? || app.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      following_app = user.following & app.users
      render :json => following_app, :status => STATUS[:OK]
    end
  end
end
