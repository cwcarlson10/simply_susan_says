class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.string :title
      t.string :image

      t.timestamps null: false
    end
  end
end
