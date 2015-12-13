class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id, index: true
      t.string :recipient_name
      t.string :recipient_email
      t.text :message
      t.string :token
      t.timestamps null: false
    end
  end
end
