class BooksController < ApplicationController

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @book_comments = BookComment.where(book_id: @book)
    @book_comment = BookComment.new
    follow_users
  end

  def index
    # @books = Book.all
    @books = Book
            .joins("left join favorites on books.id=favorites.book_id")
            .group("books.id")
            .order("count(favorites.id) desc")
    @book = Book.new
    @user = current_user
    follow_users
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def update
    is_matching_login_user
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    user_id = book.user_id.to_i
    login_user_id = current_user.id
    if(user_id != login_user_id)
      redirect_to "/books"
    end
  end

  def follow_users
    @following_users = current_user.following_user
    @follower_users = current_user.follower_user
  end
end
