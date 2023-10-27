# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 取得または登録したインスタンス = モデル.find_or_create_by!(検索キー: 検索する値) do |ブロック変数|
#   ブロック変数.属性 = 登録する値
#   :
#   :
# end

Tag.find_or_create_by!(name: "ホラー")

Tag.find_or_create_by!(name: "ファンタジー")

Tag.find_or_create_by!(name: "コメディー")

Tag.find_or_create_by!(name: "その他")

Admin.find_or_create_by!(email: "admin@test.com") do |admin|
    admin.password = '123456'
end