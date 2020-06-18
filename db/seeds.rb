# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

puts "Preparing..."

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'

html_file = open(url).read
html_doc = JSON.parse(html_file)

puts "Creating..."

html_doc['drinks'].each do |ingredient|
  Ingredient.create(name: ingredient['strIngredient1'])
  puts "Created the ingredient #{ingredient['strIngredient1']}"
end

puts "Done!"
