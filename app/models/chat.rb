class Chat < ApplicationRecord
  # before the chat creation, lock all rows by pessimistic locking
  before_create :lock_all_rows
  # before the chat update, lock all rows by pessimistic locking
  before_update :lock_all_rows
  # after the chat creation , update the application chats_count
  after_create :update_application_chats_count

  def lock_all_rows
    # Lock all rows by pessimistic locking
    Chat.lock.count # lock all rows by pessimistic locking
  end

  def update_application_chats_count
    # transaction to avoid the update of the application chats_count
    Application.transaction do
      # update the application chats_count
      application = Application.find_by(id: application_id)
      application.update(chat_counts: application.chat_counts + 1)
    end
  end

  # Chat model for the API
  # set the relation with the application
  belongs_to :application
  # set the relation with the messages
  has_many :messages, dependent: :destroy
end
