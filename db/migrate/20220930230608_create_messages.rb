class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      # message consists of
      # number which starts from 1 for each chat and increments by 1
      # chat_id which is the id of the chat that the message belongs to
      # message body which is the message body
      # Migration for the message table
      t.integer :number
      t.integer :chat_id
      t.text :body
      t.timestamps
    end
  end
end
