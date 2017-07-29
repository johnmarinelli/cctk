class CreateSnippets < ActiveRecord::Migration[5.1]
  def change
    create_table :snippets do |t|
      t.references :sketch, foreign_key: true, index: true
      t.text :content
      t.string :language

      t.timestamps
    end
  end
end
