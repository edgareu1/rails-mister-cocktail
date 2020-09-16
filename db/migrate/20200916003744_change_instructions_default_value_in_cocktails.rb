class ChangeInstructionsDefaultValueInCocktails < ActiveRecord::Migration[6.0]
  def change
    change_column :cocktails, :instructions, :text, default: nil
  end
end
