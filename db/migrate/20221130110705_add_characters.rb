class AddCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.integer :team
      t.string :unit
    end
  end
end
