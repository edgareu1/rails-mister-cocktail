class AddGlassToCocktails < ActiveRecord::Migration[6.0]
  def change
    add_reference :cocktails, :glass, null: false, foreign_key: true
  end
end
