class User::BooksController < ApplicationController
    before_action :is_matching_login_user, only: [:edit,:update]

    def new
        @book = Book.new
    end

    def index
        @books = Book.all
        #タグ検索
        @books = params[:tag_id].present? ? Tag.find(params[:tag_id]).books : Book.all
        #新規タグ作成
        if params[:tag]
         Tag.create(name: params[:tag])
        end
        @books = Book.published.order(created_at: :desc)
    end

    def show
        @book = Book.find(params[:id])
        @book_comment = BookComment.new
        @user = @book.user
    end

    def edit
        @book = Book.find(params[:id])
    end

    def create
        @book = Book.new(book_params)
        @book.user_id = current_user.id
        
        if params[:draft].present?
            @book.status = :draft
        else
            @book.status = :published
        end    
            
        if @book.save
            if @book.draft?
               redirect_to book_path(@book.id), notice: '下書きが保存されました。'
            else
                redirect_to books_path, notice: '投稿が公開されました'
            end  
        else
            render :new
        end
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        redirect_to books_path
    end

    def update
        @book = Book.find(params[:id])
        
        if params[:draft].present?
            @book.status = :draft
            notice_message = "下書きを保存しました。"
            redirect_to book_path(@book.id)
        elsif params[:unpublished].present?
            @book.status =  :unpublished   
            notice_message = "非公開にしました。"
            redirect_to book_path(@book.id)
        else
            @book.status = :published
            notice_message = "公開しました。"
            redirect_to books_path
        end    
            
        if @book.update(book_params)
            redirect_to book_path(@book.id)
        else
            render :edit
        end
    end

    private

    def book_params
        params.require(:book).permit(:title, :body, :image, :status, tag_ids:[])
    end

    def is_matching_login_user
        book = Book.find(params[:id])
        unless book.user.id == current_user.id
          redirect_to books_path
        end
    end
end
