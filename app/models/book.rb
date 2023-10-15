class Book < ApplicationRecord

    has_one_attached :image
    belongs_to :user
    
    #いいね
    has_many :favorites, dependent: :destroy
    
    #コメント
    has_many :book_comments, dependent: :destroy
    
    #タグ
    has_many :book_tag_relations, dependent: :destroy
    has_many :tags, through: :book_tag_relations, dependent: :destroy
    
    validates :title, presence: true
    validates :body, presence: true
    
    #表紙画像
    def get_image(width,height)
        unless image.attached?
            file_path = Rails.root.join('app/assets/images/no_image.jpg')
            image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
        end
            image.variant(resize_to_limit: [width, height]).processed
    end
    
    #いいね機能
    def favorited_by?(user)
        favorites.exists?(user_id: user.id)
    end
    
    def self.liked_posts(user)
      includes(:favorites)
      .where(favorites: { user_id: user.id})
      .order(created_at: :desc)
    end
    
    
    # 検索方法分岐
    def self.looks(search, word)
        if search == "perfect_match"
          @book = Book.where("title LIKE?","#{word}")
        elsif search == "forward_match"
          @book = Book.where("title LIKE?","#{word}%")
        elsif search == "backward_match"
          @book = Book.where("title LIKE?","%#{word}")
        elsif search == "partial_match"
          @book = Book.where("title LIKE?","%#{word}%")
        else
          @book = params[:tag_id].present? ? Tag.find(params[:tag_id]).books : Book.all
        end
    end    
end
