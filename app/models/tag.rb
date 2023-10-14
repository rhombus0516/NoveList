class Tag < ApplicationRecord

    has_many :book_tag_relations, dependent: :destroy
    has_many :books, through: :book_tag_relations, dependent: :destroy

    validates :name, presence: true
    validates :name, uniqueness: true

end
