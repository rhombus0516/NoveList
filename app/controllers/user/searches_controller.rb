class User::SearchesController < ApplicationController
    before_action :authenticate_user!

    def search
        @model = params[:model]
        @model = params[:word]
        @model = params[:search]

      if @model == "User"
        @users = User.looks(params[:search], params[:word])
      else
        @books = Book.looks(params[:search], params[:word])
      end
    end
end
