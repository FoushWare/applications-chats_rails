require "elasticsearch/dsl"

class Message < ApplicationRecord

  # ------------------ Race condition ------------------#
  #  before the message creation, lock all rows by pessimistic locking
  before_create :lock_all_rows
  #  before the message update, lock all rows by pessimistic locking
  before_update :lock_all_rows
  #  after the message creation , update the chat messages_count
  after_create :update_chat_messages_count
  # after the message is destroyed, update the chat messages_count
  after_destroy :update_chat_messages_count_destroy

  def lock_all_rows
    #  Lock all rows by pessimistic locking
    Message.lock.count # lock all rows by pessimistic locking
  end

  def update_chat_messages_count
    #  transaction to avoid the update of the chat messages_count
    Chat.transaction do
      #  update the chat messages_count
      chat = Chat.find_by(number: chat_id)
      chat.update(messages_count: chat.messages_count + 1)
    end
  end

  def update_chat_messages_count_destroy
    #  transaction to avoid the update of the chat messages_count
    Chat.transaction do
      #  update the chat messages_count
      chat = Chat.find_by(nubmer: chat_id)
      chat.update(messages_count: chat.messages_count - 1)
    end
  end

  # ---------------------------- Elasticsearch ----------------------------#
  # Elastic Searchable
  include Searchable

  # increase the number of shards
  settings index: {
    number_of_shards: 2,
  }

  # analysis filter and analyzer
  settings analysis: {
    filter: {
      english_stop: {
        type: "stop",
        stopwords: "_english_",
      },
      english_stemmer: {
        type: "stemmer",
        language: "english",
      },
      english_possessive_stemmer: {
        type: "stemmer",
        language: "possessive_english",
      },
      length: {
        type: "length",
        min: 1,
      },
    },
    analyzer: {
      customAnalyzer: {
        type: "custom",
        tokenizer: "my_tokenizer",
      },
    },
    tokenizer: {
      my_tokenizer: {
        type: "edge_ngram",
        min_gram: 1,
        max_gram: 20,
        token_chars: [
          "letter",
          "digit",
          "punctuation",
          "symbol",
        ],
      },
    },
  }

  # mapping is the schema for the index
  mappings dynamic: "false" do
    # custom analyzer
    indexes :body, analyzer: "customAnalyzer", index_options: "offsets", fields: { raw: { type: "text" } }
    indexes :number, type: "integer"
    indexes :application_token, type: "text"
  end

  # custom analyzer

  Message.__elasticsearch__.create_index! force: true
  Message.__elasticsearch__.refresh_index!

  # set the relation with the chat
  # belongs_to :chat
  # set the relation with the application
  # belongs_to :application
end
