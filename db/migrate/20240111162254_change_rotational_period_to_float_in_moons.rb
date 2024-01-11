class ChangeRotationalPeriodToFloatInMoons < ActiveRecord::Migration[7.0]
  def change
    change_column :moons, :rotational_period, :float
  end
end
