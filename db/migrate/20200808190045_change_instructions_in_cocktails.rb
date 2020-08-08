class ChangeInstructionsInCocktails < ActiveRecord::Migration[6.0]
  def change
    change_column :cocktails, :instructions, :text, default: "NA"
  end
end
