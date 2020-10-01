class AddInitiatingUserToConversations < ActiveRecord::Migration[6.0]
  def change
    add_reference :conversations, :initiating_user, null: false, foreign_key: { to_table: :users }
  end
end
