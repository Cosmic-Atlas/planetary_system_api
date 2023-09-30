class AddPlanetarySystemToPlanets < ActiveRecord::Migration[7.0]
  def change
    add_reference :planets, :planetary_system, foreign_key: true
  end
end
