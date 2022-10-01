class Message < ApplicationRecord
  # Message model for the API
  # set the relation with the chat
  belongs_to :chat
end
