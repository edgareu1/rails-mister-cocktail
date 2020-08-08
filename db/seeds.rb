require 'json'
require 'open-uri'

puts "Destroying existing DB..."

Cocktail.destroy_all # Doses and Reviews also destroyed as they are dependent on Cocktails
Category.destroy_all
Glass.destroy_all
Ingredient.destroy_all

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

# Creating default values for Ingredient, Category and Glass
[Category, Glass].each do |table|
  table.create(name: "NA")
  puts "Created default #{Category.name.downcase}."
end

# Populating the Ingredient, Category and Glass tables
to_populate.each do |table|
  url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?#{table[:class].name.first.downcase}=list"
  html_file = open(url).read
  html_doc = JSON.parse(html_file)

  html_doc['drinks'].each do |element|
    table[:class].create(name: element[table[:json_element]])
    puts "Created the #{table[:class].name.downcase} #{element[table[:json_element]]}."
  end
end

# Creating 20 random Cocktails
20.times do
  url = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
  html_file = open(url).read
  html_doc = JSON.parse(html_file)
  cocktail_data = html_doc['drinks'].first
  image = URI.open(cocktail_data['strDrinkThumb'])

  cocktail = Cocktail.new
  cocktail.name = cocktail_data['strDrink']
  cocktail.category = Category.find_by(name: cocktail_data['strCategory'])
  cocktail.glass = Glass.find_by(name: cocktail_data['strGlass'])
  cocktail.alcoholic = cocktail_data['strAlcoholic']
  cocktail.editable = false
  cocktail.photo.attach(io: image, filename: 'nes.png', content_type: 'image/png')
  cocktail.instructions = cocktail_data['strInstructions']

  cocktail.save

  puts "Created the #{cocktail.name} cocktail."
end

puts "Done!"
