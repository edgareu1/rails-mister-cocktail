require 'will_paginate/array'

class CocktailsController < ApplicationController
  def index
    @cocktail = Cocktail.new

    # Variable to send to the JS autoCompleteCocktail function
    gon.cocktails_names = Cocktail.all
                                  .map { |cocktail| capitalize_string(cocktail.name) }
                                  .sort
                                  .join(' -/- ')

    index_reload
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @review = Review.new
    @dose = Dose.new

    # Change the Cocktail from editable to not editable
    if params["editable"] == "1"
      @cocktail.editable = false
      @cocktail.save
    end
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)

    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    end
  end

  def update
    @cocktail = Cocktail.find(params[:id])
    @cocktail.update(cocktail_params)
  end

  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy

    redirect_to cocktails_path(anchor: "container-cards")
  end

  private

  # Method that capitalizes every word of the string passed as argument
  def capitalize_string(string)
    array_strings = string.split(' ')

    if array_strings.size == 1
      return string.capitalize
    else
      return array_strings.map(&:capitalize).join(' ')
    end
  end

  # Method that prepares the Cocktail#Index page to be displayed
  def index_reload
    @ingredients = Ingredient.all.collect(&:name).sort
    @categories = Category.all.collect(&:name).sort

    @sorted_cocktails = cocktails_sorter.paginate(page: params[:page], per_page: 12)
  end

  # Method that returns the Cocktails list sorted and filtered
  def cocktails_sorter
    cocktails_list = Cocktail.all

    # Filter by search query and sort by rating
    if params[:query].present?
      cocktails_filtered = cocktails_list.where("name ILIKE ?", "%#{params[:query]}%")
      return sort_by_rating(cocktails_filtered)

    # Sorting by the cocktails name
    elsif params[:sort_by] == "abc"
      return cocktails_list.sort_by { |cocktail| cocktail.name.downcase }

    # Filter based on the options selected by the user
    elsif params[:sort_by] == "Filter" && (params[:ingredients].present? || params[:categories].present?)
      # Filter by Ingredients
      cocktails_filtered = params[:ingredients].present? ? filter_by_ingredients(cocktails_list) : cocktails_list

      # Filter by Categories
      cocktails_filtered = params[:categories].present? ? filter_by_categories(cocktails_filtered) : cocktails_filtered

      # Sort by rating
      return sort_by_rating(cocktails_filtered)
    end

    # By default, cocktails are sorted by rating; If the user chooses to filter by ingredients but
    # does not select any option, the sorting will also be done by rating
    return sort_by_rating(cocktails_list)
  end

  # Method that returns the Cocktails list passed as param sorted by rating
  def sort_by_rating(cocktails_list)
    cocktails_list.sort_by { |cocktail| - cocktail.rating }
  end

  # Method that return the Cocktails list passed as param filtered by ingredients
  def filter_by_ingredients(cocktails_list)
    # Only cocktails with ingredients should be displayed
    cocktails_filtered = cocktails_list.reject { |cocktail| cocktail.ingredients.empty? }

    # The cocktails will first be sorted based on the number of ingredients in common with the
    # user's list and then sorted by rating
    cocktails_filtered.map! do |cocktail|
      [
        cocktail.ingredients.count { |ingredient| params[:ingredients].include?(ingredient.name) },
        cocktail.rating,
        cocktail
      ]
    end

    # If the user selects the "only_this" option the cocktails that contain other ingredients
    # will be rejected
    if params[:only_this] == "1"
      cocktails_filtered.select! { |cocktail| cocktail.first == cocktail.last.ingredients.size }

    # Nonetheless, even if the option is not selected, it should contain at least one match
    else
      cocktails_filtered.select! { |cocktail| cocktail.first >= 1 }
    end

    return cocktails_filtered.sort.reverse.map(&:last)
  end

  # Method that return the Cocktails list passed as param filtered by categories
  def filter_by_categories(cocktails_list)
    return cocktails_list.select { |cocktail| params[:categories].include?(cocktail.category.name) }
  end

  def cocktail_params
    params.require(:cocktail).permit(:name, :category_id, :glass_id, :alcoholic, :photo, :instructions)
  end
end
