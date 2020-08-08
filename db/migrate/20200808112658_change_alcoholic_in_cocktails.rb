class ChangeAlcoholicInCocktails < ActiveRecord::Migration[6.0]
  def change
    change_column :cocktails, :alcoholic, :string
  end
end
