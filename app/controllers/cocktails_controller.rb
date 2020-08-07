require 'will_paginate/array'

class CocktailsController < ApplicationController
  def index
    @cocktail = Cocktail.new
    @ingredients = Ingredient.all.sort_by(&:name)

    if params[:query].present?
      @cocktails_sorted = Cocktail.search_by_name(params[:query]).paginate(page: params[:page], per_page: 12)
    else
      @cocktails = Cocktail.all
      @cocktails_sorted = cocktails_sorter(@cocktails).paginate(page: params[:page], per_page: 12)
    end
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @review = Review.new
    @dose = Dose.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)

    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      if params[:query].present?
        @cocktails_sorted = Cocktail.search_by_name(params[:query]).paginate(page: params[:page], per_page: 12)
      else
        @cocktails = Cocktail.all
        @cocktails_sorted = cocktails_sorter(@cocktails).paginate(page: params[:page], per_page: 12)
      end

      render 'cocktails/index'
    end
  end

  private

  def cocktails_sorter(cocktails)
    # Only cocktails with ingredients will be displayed
    relevant_cocktails = cocktails.reject { |cocktail| cocktail.ingredients.empty? }

    # Sorting by popularity takes into account the cocktail's number of reviews
    if params[:sort_by] == "popularity"
      return relevant_cocktails.sort_by { |cocktail| - cocktail.reviews.size }

    # Sorting by filter takes into account the ingredient list selected by the user
    elsif params[:sort_by] == "Filter" && !params[:ingredients].nil?
      # The cocktails will first be sorted based on the number of ingredients in common with the
      # user's list and then sorted by ranking
      relevant_cocktails.map! do |cocktail|
        [
          - cocktail.ingredients.count { |ingredient| params[:ingredients].include?(ingredient.name) },
          - cocktail.rating_points,
          cocktail
        ]
      end

      # If the user selects the "only_this" option the cocktails that contain other ingredients
      # will be rejected
      if params[:only_this] == "1"
        relevant_cocktails.select! { |cocktail| - cocktail.first == cocktail.last.ingredients.size }

      # Nonetheless, even if the option is not selected, it should contain at least one match
      else
        relevant_cocktails.select! { |cocktail| - cocktail.first >= 1 }
      end

      return relevant_cocktails.sort.map(&:last)
    end

    # By default cocktails are sorted by ranking; If the user chooses to filter by ingredients but
    # does not select any, the sorting will also be done by ranking
    return relevant_cocktails.sort_by { |cocktail| - cocktail.rating_points }
  end

  def cocktail_params
    params.require(:cocktail).permit(:name, :photo)
  end
end
