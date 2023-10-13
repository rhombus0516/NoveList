class User::BooksController < ApplicationController
    before_action :is_matching_login_user, only: [:edit,:update]

    def new
        @book = Book.new
    end

    def index
        @books = Book.all
    end

    def show
        @book = Book.find(params[:id])
        @book_comment = BookComment.new
    end

    def edit
        @book = Book.find(params[:id])
    end

    def create
        @book = Book.new(book_params)
        @book.user_id = current_user.id
        @book.save
        redirect_to books_path
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        redirect_to books_path
    end

    def update
        book = Book.find(params[:id])
        book.update(book_params)
        redirect_to book_path(book.id)
    end

    private

    def book_params
        params.require(:book).permit(:title, :body, :image, tag_ids:[])
    end
    
    def is_matching_login_user
        book = Book.find(params[:id])
        unless book.id == current_user.id
          redirect_to books_path
        end
    end
end
