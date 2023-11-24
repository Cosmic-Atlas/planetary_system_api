class CreateMoons < ActiveRecord::Migration[7.0]
  def change
    create_table :moons do |t|
      t.string :name
      t.bigint :radius_km
      t.integer :rotational_period
      t.float :magnitude
      t.references :planet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
