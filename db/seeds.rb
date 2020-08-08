require 'json'
require 'open-uri'

puts "Destroying existing DB..."

Category.destroy_all
Cocktail.destroy_all
Dose.destroy_all
Glass.destroy_all
Ingredient.destroy_all
Review.destroy_all

puts "Preparing to create..."

to_populate = [
  {
    class: Ingredient,
    json_element: 'strIngredient1'
  },

  {
    class: Category,
    json_element: 'strCategory'
  },

  {
    class: Glass,
    json_element: 'strGlass'
  }
]

puts "Creating..."

to_populate.each do |table|
  url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?#{table[:class].name.first.downcase}=list"
  html_file = open(url).read
  html_doc = JSON.parse(html_file)

  html_doc['drinks'].each do |element|
    table[:class].create(name: element[table[:json_element]])
    puts "Created the #{table[:class].name.downcase} #{element[table[:json_element]]}"
  end
end

puts "Done!"
