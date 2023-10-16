class Admin::HomesController < ApplicationController
    
    def top
        @books = Book.all
    end
end
