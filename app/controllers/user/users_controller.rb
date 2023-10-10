class User::UsersController < ApplicationController
    
    def show
        @user = User.find(params[:id])
        @books = @user.book
    end
    
    def edit
        @user = User.find(params[:id])
    end    
end
