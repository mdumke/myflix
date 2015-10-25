class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :queue_position

      t.integer :video_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
