class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.integer :category_id
      t.string :large_cover_url
      t.string :small_cover_url

      t.timestamps null: false
    end
  end
end
