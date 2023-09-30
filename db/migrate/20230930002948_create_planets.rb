class CreatePlanets < ActiveRecord::Migration[7.0]
  def change
    create_table :planets do |t|
      t.string :name
      t.string :planet_type
      t.integer :year_discovered
      t.boolean :confirmed

      t.timestamps
    end
  end
end
