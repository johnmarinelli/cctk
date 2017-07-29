class CreateSketches < ActiveRecord::Migration[5.1]
  def change
    create_table :sketches do |t|
      t.references :user, foreign_key: true, index: true
      t.string :title
      t.string :sketch_type

      t.timestamps
    end
  end
end
