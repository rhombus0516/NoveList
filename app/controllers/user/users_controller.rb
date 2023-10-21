class User::UsersController < ApplicationController
    #before_action :authenticate_user!
    before_action :ensure_guest_user, only: [:edit]
    before_action :is_matching_login_user, only: [:edit, :update]
    
    def index
        @users = User.all
        @book = Book.new
        @books = Book.all
    end
    
    def show
        @user = User.find(params[:id])
        @books = @user.book
        @following_users = @user.following_users
        @follower_users = @user.follower_users
    end
    
    def edit
        @user = User.find(params[:id])
    end    
    
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "変更を保存しました"
            redirect_to user_path(@user)
        else
            flash[:notice] = "保存に失敗しました"
            render:edit
        end    
    end
    
    def destroy
        @user =User.find(params[:id])
        @user.destroy
        redirect_to root_path
    end
    
    def follows
        user = User.find(params[:id])
        @user = user.following_users
    end
    
    def followers
        user = User.find(params[:id])
        @user = user.follower_users
    end
    
        
    def liked_posts
        @liked_posts = Book.liked_posts(current_user)
        @books = current_user.books
    end    
    
      private

    def user_params
        params.require(:user).permit(:name, :profile_image, :introduction)
    end
    
    def is_matching_login_user
        user = User.find(params[:id])
        unless user.id == current_user.id
          redirect_to books_path
        end
    end
    
    def ensure_guest_user
        @user = User.find(params[:id])
        if @user.guest_user?
          redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
        end
    end  
end
