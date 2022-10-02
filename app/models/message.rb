require "elasticsearch/model"

class Message < ApplicationRecord
  # configure the model to work with elastic search model
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # define the index name
  index_name "messages-#{Rails.env}"

  # define the index settings
  settings index: { number_of_shards: 1 } do
    mappings dynamic: "false" do
      indexes :body, analyzer: "english"
    end
  end

  # define the index document
  def as_indexed_json(options = {})
    as_json(only: [:body])
  end

  # define the search method
  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ["body"],
          },
        },
        # highlight
        highlight: {
          pre_tags: ["<em>"],
          post_tags: ["</em>"],
          fields: {
            body: {},
          },
          # suggest
          suggest: {
            text: query,
            message_suggestion: {
              term: {
                field: "body",
                suggest_mode: "always",
              },
            },
          },
        },
      }
    )
  end

  # Message model for the API
  # set the relation with the chat
  belongs_to :chat
end
