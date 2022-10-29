class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # DM機能用
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @UserEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @UserEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
      @room = Room.new
      @entry = Entry.new
      end
    end

    # フォローユーザー設定
    follow_users
  end

  def index
    @users = User.all
    @book = Book.new
    follow_users
  end

  def edit
    ensure_correct_user
    @user = User.find(params[:id])
  end

  def update
    ensure_correct_user
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def follow_users
    @following_users = current_user.following_user
    @follower_users = current_user.follower_user
  end

end
