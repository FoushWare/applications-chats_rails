class Chat < ApplicationRecord
  # Chat model for the API
  # set the relation with the application
  belongs_to :application
  # set the relation with the messages
  has_many :messages, dependent: :destroy
end
