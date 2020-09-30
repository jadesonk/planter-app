class CreatePlants < ActiveRecord::Migration[6.0]
  def change
    create_table :plants do |t|
      t.string :common_name
      t.string :sun
      t.string :water
      t.integer :max_height
      t.string :duration_to_harvest
      t.boolean :trellis_support

      t.timestamps
    end
  end
end
