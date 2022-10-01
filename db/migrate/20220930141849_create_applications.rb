class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      # application consists of
      # token: which identify the user device which send chats to the application
      # name: which is the name of the application
      # chat_counts which is the number of chats sent to the application
      # Migration for the application table
      t.string :token
      t.string :name
      t.integer :chat_counts, default: 0
      t.timestamps
    end
  end
end
