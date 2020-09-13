class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    @cocktail = Cocktail.find(params[:cocktail_id])
    @review.cocktail = @cocktail

    # In case there's an error saving the new review
    unless @review.save
      @dose = Dose.new
      render 'cocktails/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
