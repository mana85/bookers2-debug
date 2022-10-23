class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_back(fallback_location: root_path)
  end
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_back(fallback_location: root_path)
  end
  def followed
    user = User.find(params[:user_id])
    @users = user.list_of_followed
  end
  def followers
    user = User.find(params[:user_id])
    @users = user.list_of_followers
  end
end
