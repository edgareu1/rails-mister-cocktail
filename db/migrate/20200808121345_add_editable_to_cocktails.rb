class AddEditableToCocktails < ActiveRecord::Migration[6.0]
  def change
    add_column :cocktails, :editable, :boolean, default: true
  end
end
