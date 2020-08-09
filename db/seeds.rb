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

# Creates default values for Category and Glass
[Category, Glass].each do |table|
  table.create(name: "NA")
  puts "Created default #{Category.name.downcase}"
end

# Populates the Ingredient, Category and Glass tables
to_populate.each do |table|
  url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?#{table[:class].name.first.downcase}=list"
  html_file = open(url).read
  html_doc = JSON.parse(html_file)

  html_doc['drinks'].each do |element|
    table[:class].create(name: element[table[:json_element]])
    puts "Created the #{table[:class].name.downcase} #{element[table[:json_element]]}"
  end
end

# Method that generates a random cocktail. It handles the whole process of fetching data from the API
def random_cocktail_generator
  url = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
  html_file = open(url).read
  html_doc = JSON.parse(html_file)
  data = html_doc['drinks'].first

  # Makes sure a Cocktail with the same name doesn't already exist (name has an uniqueness validation)
  if Cocktail.find_by(name: data['strDrink']).nil?
    new_cocktail = create_cocktail(data)
    counter = create_cocktail_doses(data, new_cocktail)

    puts "Created the #{new_cocktail.name} cocktail with #{counter} doses"
  end
end

# Method that creates and returns a Cocktail based on the data passed
def create_cocktail(data)
  new_cocktail = Cocktail.new

  new_cocktail.editable = false
  new_cocktail.name = data['strDrink']
  new_cocktail.alcoholic = data['strAlcoholic']
  new_cocktail.instructions = data['strInstructions']

  image = URI.open(data['strDrinkThumb'])
  new_cocktail.photo.attach(io: image, filename: 'nes.png', content_type: 'image/png')

  category = Category.find_by(name: data['strCategory'])
  category = Category.find_by(name: "NA") if category.nil?

  glass = Glass.find_by(name: data['strGlass'])
  glass = Glass.find_by(name: "NA") if glass.nil?

  new_cocktail.category = category
  new_cocktail.glass = glass

  new_cocktail.save

  return new_cocktail
end

# Method that takes data and a Cocktail as arguments and creates, based on that data, that same
# Cocktail's doses; returns the number of doses created
def create_cocktail_doses(data, new_cocktail)
  counter = 1

  until data["strIngredient#{counter}"].nil? || data["strIngredient#{counter}"].empty?
    dose = Dose.new(description: data["strMeasure#{counter}"])

    ingredient = Ingredient.find_by(name: data["strIngredient#{counter}"])
    ingredient = Ingredient.create(name: data["strIngredient#{counter}"]) if ingredient.nil?

    dose.ingredient = ingredient
    dose.cocktail = new_cocktail

    dose.save

    counter += 1
  end

  return counter
end

# Creating 50 random Cocktails
50.times do
  random_cocktail_generator
end

# Makes sure 50 Cocktails where created
until Cocktail.all.size == 50
  random_cocktail_generator
end

puts "Done!"
