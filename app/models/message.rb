class Message < ApplicationRecord
  include Searchable
  # Message.__elasticsearch__.create_index!
  # Message.import
  # Message model for the API
  # set the relation with the chat
  belongs_to :chat
end
