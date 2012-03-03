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
    if request.get?
    elsif request.post?
      
      if params[:google_ids]
    end
end
