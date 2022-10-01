class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      # chat consists of
      # number which starts from 1 for each application and increments by 1
      # application_id which is the id of the application that the chat belongs to
      # messages_count which is the number of messages sent to the chat
      # Migration for the chat table
      t.integer :number
      t.integer :application_id
      t.integer :messages_count, default: 0
      t.timestamps
    end
  end
end
