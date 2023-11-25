class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy

  validates :name, presence: true,length: { in: 1..10 }
  validates :introduction, length: { maximum: 100 }

  #ユーザー画像
  has_one_attached :profile_image

  #いいね
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, through: :favorites,source: 'book'
  
  #コメント
  has_many :book_comments, dependent: :destroy

  #閲覧数
  has_many :view_counts, dependent: :destroy

  #フォロー
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  #フォロワー
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower

  #フォローしたときの処理
  def follow(user_id)
    followers.create(followed_id: user_id)
  end

  #フォローを外すときの処理
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end

  #フォローしているか確認
  def following?(user)
    following_users.include?(user)
  end

  #ゲストログイン

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  #ユーザー画像
  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.PNG')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.PNG', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
  end

  #検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
end

