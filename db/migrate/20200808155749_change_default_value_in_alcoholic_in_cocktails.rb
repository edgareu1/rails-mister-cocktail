class ChangeDefaultValueInAlcoholicInCocktails < ActiveRecord::Migration[6.0]
  def change
    change_column :cocktails, :alcoholic, :string, default: "Optional"
  end
end
