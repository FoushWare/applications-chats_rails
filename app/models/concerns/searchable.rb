require "elasticsearch/model"

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    #-------- Config for Elastic search -------#
    # settings index: {
    #   number_of_shards: 2,
    # } do
    #   # mapping is the schema for the index
    #   mappings dynamic: "false" do
    #     # custom analyzer
    #     indexes :body, analyzer: "english", index_options: "offsets", fields: { raw: { type: "text" } }
    #   end
    # end

    def as_indexed_json(options = {})
      self.as_json(
        only: [:body],
      )
    end

    # searchMessages function
    def self.searchMessages(query)
      params = {
        # i want to search for each character in the query
        query: {
          multi_match: {
            query: query,
            fields: ["body"],
          },
        },

      }

      self.__elasticsearch__.search(params)
    end
  end
end
