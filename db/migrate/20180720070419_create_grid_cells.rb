class CreateGridCells < ActiveRecord::Migration[5.2]
  def change
    create_table :grid_cells do |t|
      t.integer :row
      t.integer :column
      t.string :color
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
