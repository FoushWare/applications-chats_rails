require "elasticsearch/dsl"

class Message < ApplicationRecord
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
  end

  # custom analyzer

  Message.__elasticsearch__.create_index! force: true
  Message.__elasticsearch__.refresh_index!

  # set the relation with the chat
  belongs_to :chat
end
