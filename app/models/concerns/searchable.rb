require "elasticsearch/model"

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    #-------- Config for Elastic search -------#

    def as_indexed_json(options = {})
      self.as_json(
        only: [:body, :number, :application_token],
      )
    end

    #     GET messages / _search

    # {
    #   "query": {
    #     "bool": {
    #       "must": [
    #         {
    #           "match": {
    #             "body": "zico",
    #           },
    #         },
    #         {
    #           "match": {
    #             "chat_id": 18,
    #           },

    #         },
    #         {
    #           "match": {
    #             "application_token": "169d53674ba5196250fd",
    #           },
    #         },
    #       ],
    #     },
    #   },
    # }

    # searchMessages function
    def self.searchMessages(query, token, chatNumber)
      params = {
        # i want the search based on finding the query in the body of the message
        # and the chat_id and the application_token of the message should be the same as the ones in the params [token, chatNumber]
        query: {
          bool: {
            must: [
              {
                match: {
                  body: query,
                },
              },
              {
                match: {
                  number: chatNumber,
                },
              },
              {
                match: {
                  application_token: token,
                },
              },
            ],
          },
        },
        # specify the fields that i want to return
        _source: ["body"],
      }
      # get the results of the search and get only the body of the message
      self.__elasticsearch__.search(params).results.map { |result| result._source.body }
    end
  end
end
