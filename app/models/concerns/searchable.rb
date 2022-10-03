require "elasticsearch/model"

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    Message.__elasticsearch__.create_index!
    Message.import

    def self.search(query)
      # ...
    end
  end
end
