class CocktailsController < ApplicationController
  def index
    @cocktail = Cocktail.new
    @cocktails = Cocktail.all
    @cocktails_sorted = cocktails_sorter(@cocktails)
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @dose = Dose.new
    @review = Review.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)

    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render :index
    end
  end

  private

  def cocktails_sorter(cocktails)
    cocktails.sort_by { |cocktail| - cocktail.relevance_points }
  end

  def cocktail_params
    params.require(:cocktail).permit(:name, :photo)
  end
end
