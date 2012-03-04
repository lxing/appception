class UsersController < ApplicationController
  def new
    y params
    user = User.new({
      :name => params[:name],
      :email => params[:email],
      :fb_id => params[:fb_id]
    })
    if user.save
      render :json => user, :status => STATUS[:OK]
    else
      render :json => nil, :status => STATUS[:INVALID]
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
    user = User.find_by_fb_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      render :json => user.apps, :status => STATUS[:OK]
    end
  end

  def setapps
    user = User.find_by_fb_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      google_ids = params[:app_ids]
      names = params[:names]

      if google_ids.blank?
        render :json => [], :status => STATUS[:INVALID]
      else
        updated_apps = []

        google_ids.zip(names).each do |pair|
          google_id = pair[0]
          name = pair[1]

          app = App.find_by_google_id(google_id) || App.sync(google_id)
          if app.present?
            updated_apps << app
          else
            app = App.new({
              :google_id => google_id,
              :name => name,
              :description => "no description available",
              :icon => "https://lh3.ggpht.com/lkP4CK75qzystxLe5uXVDWFCs_mSbYSTGcpMzVCO7idlECDiv3Yl5P5HcZEVoL5yrxmd=w124"
            })
            updated_apps << app if app.save
          end
        end

        user.apps = updated_apps
        updated_app_ids = updated_apps.map{|app| app.id}

        render :json => updated_app_ids, :status => STATUS[:OK]
      end
    end
  end

  def following
    user = User.find_by_fb_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      following = user.following
      render :json => following, :status => STATUS[:OK]
    end
  end

  def followers
    user = User.find_by_fb_id(params[:id])
    if user.nil?
      render :json => [], :status => STATUS[:INVALID]
    else
      followers = user.followers
      render :json => followers, :status => STATUS[:OK]
    end
  end

  def follow
    user = User.find_by_fb_id(params[:id])
    targets = User.find_all_by_fb_id(params[:fb_ids])
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
    user = User.find_by_fb_id(params[:id])
    targets = User.find_all_by_fb_id(params[:fb_ids])
    if user.nil?
      render :json => false, :status => STATUS[:INVALID]
    else
      targets.each do |target|
        user.follow(target)
      end
      render :json => true, :status => STATUS[:OK]
    end
  end
end
