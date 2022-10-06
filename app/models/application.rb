class Application < ApplicationRecord

  # validates the name of the application
  validates :name, presence: true, uniqueness: true
  # when update the application, lock all rows by pessimistic locking
  before_update :lock_all_rows
  # before the application creation, lock all rows by pessimistic locking
  before_create :lock_all_rows

  # Application model for the API
  # set the relation with the chats
  has_many :chats, dependent: :destroy
  # set the relation with the messages
  has_many :messages, through: :chats

  # Lock all rows by pessimistic locking
  def lock_all_rows
    # Lock all rows by pessimistic locking
    Application.lock.count # lock all rows by pessimistic locking
  end

  # then , create the application must always be done in transaction
  # and the transaction must be done with the lock of all rows
  # to avoid the creation of two applications with the same name

  # to_param method for the application readability  becasue i will use :token in the url not :id
  def to_param
    token
  end
end
