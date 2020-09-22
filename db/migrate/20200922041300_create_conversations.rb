class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
