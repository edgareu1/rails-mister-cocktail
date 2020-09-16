class ChangeAlcoholicDefaultValueInCocktails < ActiveRecord::Migration[6.0]
  def change
    change_column :cocktails, :alcoholic, :string, default: nil
  end
end
