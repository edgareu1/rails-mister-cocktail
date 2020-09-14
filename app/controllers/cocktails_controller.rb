require 'will_paginate/array'

class CocktailsController < ApplicationController
  def index
    @cocktail = Cocktail.new
    gon.cocktails_names = Cocktail.all
                                  .map(&:name)
                                  .join(' -/- ')

    index_reload
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @review = Review.new
    @dose = Dose.new

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

  # Method that prepares the Cocktail#Index page to be displayed
  def index_reload
    @ingredients = Ingredient.all.collect(&:name).sort
    @categories = Category.all.collect(&:name).sort

    @cocktails_sorted = cocktails_sorter.paginate(page: params[:page], per_page: 12)
  end

  # Method that sorts and filters the Cocktails to be displayed
  def cocktails_sorter
    # Filtering by search query
    if params[:query].present?
      return Cocktail.search_by_name(params[:query])

    # Sorting by the cocktails name
    elsif params[:sort_by] == "abc"
      return Cocktail.all.sort_by { |cocktail| cocktail.name.downcase }

    # Filtering by the options selected by the user
    elsif params[:sort_by] == "Filter" && (params[:ingredients].present? || params[:categories].present?)
      cocktails_sorted = params[:ingredients].present? ? filter_by_ingredients : cocktails_sorted_by_rating   # Filter by Ingredients
      cocktails_sorted = filter_by_categories(cocktails_sorted) if params[:categories].present?               # Filter by Categories

      return cocktails_sorted
    end

    # By default cocktails are sorted by ranking; If the user chooses to filter by ingredients but
    # does not select any, the sorting will also be done by ranking
    return cocktails_sorted_by_rating
  end

  def cocktails_sorted_by_rating
    Cocktail.all.sort_by { |cocktail| - cocktail.rating_points }
  end

  def filter_by_ingredients
    # Only cocktails with ingredients should be displayed
    relevant_cocktails = Cocktail.all.reject { |cocktail| cocktail.ingredients.empty? }

    # The cocktails will first be sorted based on the number of ingredients in common with the
    # user's list and then sorted by ranking
    relevant_cocktails.map! do |cocktail|
      [
        cocktail.ingredients.count { |ingredient| params[:ingredients].include?(ingredient.name) },
        cocktail.rating_points,
        cocktail
      ]
    end

    # If the user selects the "only_this" option the cocktails that contain other ingredients
    # will be rejected
    if params[:only_this] == "1"
      relevant_cocktails.select! { |cocktail| cocktail.first == cocktail.last.ingredients.size }

    # Nonetheless, even if the option is not selected, it should contain at least one match
    else
      relevant_cocktails.select! { |cocktail| cocktail.first >= 1 }
    end

    return relevant_cocktails.sort.reverse.map(&:last)
  end

  def filter_by_categories(cocktails)
    return cocktails.select { |cocktail| params[:categories].include?(cocktail.category.name) }
  end

  def cocktail_params
    params.require(:cocktail).permit(:name, :category_id, :glass_id, :alcoholic, :photo, :instructions)
  end
end
