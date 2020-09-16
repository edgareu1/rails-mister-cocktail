class DosesController < ApplicationController
  before_action :set_cocktail, only: [:create, :destroy]

  # If a dose with that ingredient does not exist, then create a new one
  # Otherwise update the already existing dose with the same ingredient
  def create
    @cocktail = Cocktail.find(params[:cocktail_id])

    existing_dose = @cocktail.doses.find_by(ingredient_id: params["dose"]["ingredient_id"])

    if existing_dose.nil?
      @dose = Dose.new(dose_params)
      @dose.cocktail = @cocktail

      # In case there's an error saving the new dose (which at the moment is not possible)
      unless @dose.save
        @review = Review.new
        render 'cocktails/show'
      end

    else
      update(existing_dose)
    end
  end

  def update(existing_dose)
    successful_update = existing_dose.update(dose_params)

    # In case there's an error saving the new dose (which at the moment is not possible)
    unless successful_update
      @review = Review.new
      render 'cocktails/show'
    end
  end

  def destroy
    @dose = Dose.find(params[:id])
    @dose.destroy
  end

  private

  def dose_params
    params.require(:dose).permit(:description, :ingredient_id)
  end

  def set_cocktail
    @cocktail = Cocktail.find(params[:cocktail_id])
  end
end
