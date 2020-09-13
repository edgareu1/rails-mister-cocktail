class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    @cocktail = Cocktail.find(params[:cocktail_id])
    @review.cocktail = @cocktail
    @review.save
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
