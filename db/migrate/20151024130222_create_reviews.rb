class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :text
    
      t.integer :video_id
      t.integer :user_id

      t.timestamps null: false

      t.index :video_id
      t.index :user_id
    end
  end
end
