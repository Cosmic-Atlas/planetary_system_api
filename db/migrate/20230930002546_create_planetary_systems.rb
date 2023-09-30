class CreatePlanetarySystems < ActiveRecord::Migration[7.0]
  def change
    create_table :planetary_systems do |t|
      t.string :name
      t.integer :light_years_from_earth
      t.bigint :star_age

      t.timestamps
    end
  end
end
