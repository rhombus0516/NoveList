class User::BooksController < ApplicationController
    before_action :is_matching_login_user, only: [:edit,:update]

    def new
        @book = Book.new
    end

    def index
        @books = Book.all
        #タグ検索
        if params[:tag_id].present?
        tag = Tag.find(params[:tag_id])
        @books = tag.books
        end
        #新規タグ作成
        if params[:tag]
         Tag.create(name: params[:tag])
        end
        
    
        @books = @books.published.order(created_at: :desc)
    end

    def show
        @book = Book.find(params[:id])
        @book_comment = BookComment.new
        @user = @book.user
        if user_signed_in?
            unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
                current_user.view_counts.create(book_id: @book.id)
            end
        end
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
                flash.now[:notice] = "下書きが保存されました。"
                redirect_to book_path(@book.id)
            else
                flash.now[:notice] = "投稿が公開されました"
                redirect_to books_path, notice: '投稿が公開されました'
            end
        else
            flash.now[:notice] = "保存に失敗しました"
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

        @book.assign_attributes(book_params)

        if params[:draft].present?
            @book.status = :draft
            notice_message = "下書きを保存しました。"
            redirect_path =  book_path(@book.id)
        elsif params[:unpublished].present?
            @book.status = :unpublished
            notice_message = "非公開にしました。"
            redirect_path = books_path
        elsif params[:published].present?
            @book.status = :published
            notice_message = "公開しました。"
            redirect_path = books_path
        end
        if @book.save
            redirect_to redirect_path, notice: notice_message
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
