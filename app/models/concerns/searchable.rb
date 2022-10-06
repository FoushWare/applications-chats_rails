require "elasticsearch/model"

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    #-------- Config for Elastic search -------#

    def as_indexed_json(options = {})
      self.as_json(
        only: [:body],
      )
    end

    # searchMessages function
    def self.searchMessages(query, token, chatNumber)
      params = {
        # i want to search for each character in the query
        query: {
          bool: {
            must: {
              #  the query should be in the body of the message and the chat number should be the same and the application token should be the same
              multi_match: {
                query: query,
                fields: ["body"],
              },
            },
            filter: [
              {
                term: {
                  chat_id: chatNumber,
                },
              },
              {
                term: {
                  application_token: token,
                },
              },
            ],
          },
        },
      }

      self.__elasticsearch__.search(params)
    end
  end
end
