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

    # 投稿数計測
    # 日付調べる
    today = Date.today
    # 前日比
    @todayBooks = @books.where(created_at: today.all_day).count
    @yestBooks = @books.where(created_at: (today-1).all_day).count
    @dayBefore = comparison(@todayBooks, @yestBooks)
    # 前週比
    @today_books = @books.where(:created_at => (today-7).beginning_of_day..today.end_of_day)
    # @thisWeekBooks = @books.where(created_at: Date.today.all_week(day[wday+1])).count
    @thisWeekBooks = @books.where(:created_at => (today-7).beginning_of_day..today.end_of_day).count
    @lastWeekBooks = @books.where(:created_at => (today-14).beginning_of_day..(today-8).end_of_day).count
    @weekBefore = comparison(@thisWeekBooks, @lastWeekBooks)

    # 過去7日分の日別投稿数
    @dailyBookCounts = Array.new
    (0..6).each do |i|
      count = @books.where(created_at: (today-i).all_day).count
      @dailyBookCounts.insert(0, (count))
    end
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

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ?', "#{create_at}%"]).count
    end
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

  def comparison(now,before)
    if before == 0
      return "－"
    else
      comp = (now.to_f / before.to_f)*100
      return comp.round.to_s + "％"
    end
  end

end
