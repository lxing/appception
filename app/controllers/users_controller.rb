class UsersController < ApplicationController

  def find
    users = []
    if params[:name].present?
      users = User.find_all_by_name(params[:name])
    elsif params[:email].present?
      users = User.find_all_by_email(params[:email])
    elsif params[:fb_id].present?
      users = User.find_all_by_fb_id(params[:fb_id])
    end

    render :json => users, :status => STATUS[:OK]
  end

  def apps
    user = User.find_by_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    elsif request.post?
      render :json => user.apps, :status => STATUS[:OK]
    elsif request.get?
      google_ids = params[:google_ids]
      if google_ids.blank?
        render :json => [], :status => STATUS[:INVALID]
      else
        updated_apps = []
        google_ids.each do |google_id|
          app = App.find_by_google_id(google_id) || App.sync(google_id)
          if app.present?
            updated_apps << app
          end
        end

        user.apps = updated_apps
        updated_app_ids = updated_apps.map{|app| app.id}

        render :json => updated_app_ids, :status => STATUS[:OK]
      end
    end
  end

  def following
    user = User.find_by_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      following = user.following
      render :json => following, :status => STATUS[:OK]
    end
  end

  def followers
    user = User.find_by_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      followers = user.followers
      render :json => followers, :status => STATUS[:OK]
    end
  end

  def follow
    user = User.find_by_id(params[:id])
    target = User.find_by_id(params[:target_id])
    if user.nil? || target.nil?
      render :json => false, :status => STATUS[:INVALID]
    else
      user.follow(target)
      render :json => true, :status => STATUS[:OK]
    end
  end

  def unfollow
    user = User.find_by_id(params[:id])
    target = User.find_by_id(params[:target_id])
    if user.nil? || target.nil?
      render :json => false, :status => STATUS[:INVALID]
    else
      user.unfollow(target)
      render :json => true, :status => STATUS[:OK]
    end
  end
end
