class UsersController < ApplicationController
  def new
    user = User.new({
      :name => params[:name],
      :email => params[:email],
      :fb_id => params[:fb_id]
    })
    if user.save
      render :json => nil, :status => STATUS[:INVALID]
    else
      render :json => user, :status => STATUs[:OK]
    end
  end

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
    elsif request.get?
      render :json => user.apps, :status => STATUS[:OK]
    elsif request.post?
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
    targets = User.find_all_by_id(params[:target_ids])
    if user.nil?
      render :json => false, :status => STATUS[:INVALID]
    else
      targets.each do |target|
        user.follow(target)
      end
      render :json => true, :status => STATUS[:OK]
    end
  end

  def unfollow
    user = User.find_by_id(params[:id])
    targets = User.find_all_by_id(params[:target_ids])
    if user.nil? || target.nil?
      render :json => false, :status => STATUS[:INVALID]
    else
      targets.each do |target|
        user.follow(target)
      end
      render :json => true, :status => STATUS[:OK]
    end
  end
end
