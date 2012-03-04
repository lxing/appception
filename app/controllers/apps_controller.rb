class AppsController < ApplicationController
  def topapps
    user = User.find_by_fb_id(params[:user_id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      existing = Set.new(user.apps)
      app_weights = Hash.new(0)
      user.following.each do |followed|
        followed.apps.each do |app|
          app_weights[app] += 1 unless existing.include?(app)
        end
      end

      topapps = app_weights.to_a
      topapps = topapps.sort{|a,b| b[1] - a[1]}

      render :json => topapps, :status => STATUS[:OK]
    end
  end

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
