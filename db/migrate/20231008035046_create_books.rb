class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      
      t.string :title
      t.text :body
      t.string :user_id
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
  end
end
