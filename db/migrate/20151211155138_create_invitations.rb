class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id, index: true
      t.integer :recipient_id, index: true
      t.text :message
      t.timestamps null: false
    end
  end
end
