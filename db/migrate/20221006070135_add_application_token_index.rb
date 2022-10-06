class AddApplicationTokenIndex < ActiveRecord::Migration[5.2]
  def change
    # add index to the application table
    # to make sure that the application token is unique
    # and that the application token is indexed
    # so that it can be searched faster
    add_index :applications, :token, unique: true
  end
end
