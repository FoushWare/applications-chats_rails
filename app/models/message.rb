class Message < ApplicationRecord
  # Message model for the API
  # set the relation with the chat
  belongs_to :chat
  # set the relation with the application
  belongs_to :application
end
