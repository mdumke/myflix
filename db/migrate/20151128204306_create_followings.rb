class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :user_id, index: true
      t.integer :follower_id, index: true
    end
  end
end
