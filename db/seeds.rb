require 'json'
require 'open-uri'
require 'faker'

# Capitalizes the multiples words of a string
def capitalize_string(string)
  string.split.map(&:capitalize).join(" ")
end

puts "Destroying existing DB..."

Cocktail.destroy_all # Doses and Reviews also destroyed as they are dependent on Cocktails
Category.destroy_all
Glass.destroy_all
Ingredient.destroy_all

puts "Creating..."

# Populates the Ingredients table
url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
html_file = open(url).read
html_doc = JSON.parse(html_file)

html_doc['drinks'].each do |ingredient|
  ingredient_name = capitalize_string(ingredient["strIngredient1"])
  Ingredient.create(name: ingredient_name)
  puts "Created the ingredient #{ingredient_name}"
end

# Populates the Glass and Category tables with controlable values
# The API is too unpredictable in regards to the names given to this classes
glasses_array = [
  "NA", "Champagne Flute", "Collins Glass", "Cocktail Glass", "Goblet", "Mug",
  "Plastic Cup", "Shot Glass", "Teacup", "Vodka Glass", "Wine Glass", "Yard"
]

categories_array = [
  "NA", "Beer", "Cocktail", "Cocoa", "Coffee", "Juice", "Liqueur", "Milk",
  "Party Drink", "Shot", "Soft Drink", "Tea"
]

[[Glass, glasses_array], [Category, categories_array]].each do |table|
  table[1].each do |element_name|
    table[0].create(name: element_name)
    puts "Created the #{table[0].name.downcase} #{element_name}"
  end
end

# Method that generates a random cocktail. It handles the whole process of fetching data from the API
def random_cocktail_generator
  url = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
  html_file = open(url).read
  html_doc = JSON.parse(html_file)
  data = html_doc['drinks'].first

  # Makes sure a Cocktail with the same name doesn't already exist (name has an uniqueness validation)
  if Cocktail.find_by(name: capitalize_string(data['strDrink'])).nil?
    new_cocktail = create_cocktail(data)
    num_doses = create_cocktail_doses(data, new_cocktail)
    num_reviews = create_cocktail_reviews(new_cocktail)

    puts "Created the #{new_cocktail.name} cocktail with #{num_doses} doses and #{num_reviews} reviews"
  end
end


# Transforms the API category names in the corresponding names in this app
Transform_category = {
  "Ordinary Drink" => "Juice",
  "Cocktail" => "Cocktail",
  "Milk / Float / Shake" => "Milk",
  "Other/unknown" => "NA",
  "Cocoa" => "Cocoa",
  "Shot" => "Shot",
  "Coffee / Tea" => "Coffee",
  "Homemade Liqueur" => "Liqueur",
  "Punch / Party Drink" => "Party Drink",
  "Beer" => "Beer",
  "Soft Drink / Soda"  => "Soft Drink"
}

# Method that creates and returns a Cocktail based on the data passed
def create_cocktail(data)
  new_cocktail = Cocktail.new

  new_cocktail.editable = false
  new_cocktail.name = capitalize_string(data['strDrink'])
  new_cocktail.alcoholic = data['strAlcoholic']
  new_cocktail.instructions = data['strInstructions']

  image = URI.open(data['strDrinkThumb'])
  new_cocktail.photo.attach(io: image, filename: 'nes.png', content_type: 'image/png')

  category = Category.find_by(name: Transform_category[capitalize_string(data['strCategory'])])
  category = Category.find_by(name: "NA") if category.nil?

  glass = Glass.find_by(name: capitalize_string(data['strGlass']))
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

    ingredient_name = capitalize_string(data["strIngredient#{counter}"])
    ingredient = Ingredient.find_by(name: ingredient_name)
    ingredient = Ingredient.create(name: ingredient_name) if ingredient.nil?

    dose.ingredient = ingredient
    dose.cocktail = new_cocktail

    dose.save

    counter += 1
  end

  return counter
end

# Method that creates 5..10 random reviews to a Cocktail passed as argument
def create_cocktail_reviews(new_cocktail)
  num_reviews = rand(5..10).times do
    review = Review.new

    review.rating = Math.sqrt(rand(0..30)).floor  # Random ratings between 0..5 biased towards 3..5
    review.content = Faker::Restaurant.review     # Uses Restaurant fake reviews
    review.cocktail = new_cocktail

    review.save
  end

  return num_reviews
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
