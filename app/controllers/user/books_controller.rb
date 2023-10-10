class User::BooksController < ApplicationController

    def new
        @book = Book.new
    end

    def index
        @books = Book.all
    end

    def show
        @books = Book.find(params[:id])
    end

    def edit
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

    private

    def book_params
        params.require(:book).permit(:title, :body, :image)
    end

end
