class RemoveImageUrlFromCocktails < ActiveRecord::Migration[6.0]
  def change
    remove_column :cocktails, :image_url
  end
end
