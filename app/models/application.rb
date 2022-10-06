class Application < ApplicationRecord

  # Application model for the API
  # set the relation with the chats
  has_many :chats, dependent: :destroy
  # set the relation with the messages
  has_many :messages, through: :chats
end
