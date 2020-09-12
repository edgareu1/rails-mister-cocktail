class DosesController < ApplicationController
  before_action :set_cocktail, only: [:create, :update, :destroy]

  def create
    # If a dose with that ingredient does not exist, then create a new one
    # Otherwise update the already existing dose with the same ingredient
    if @cocktail.doses.find_by(ingredient_id: params["dose"]["ingredient_id"]).nil?
      @dose = Dose.new(dose_params)
      @dose.cocktail = @cocktail

      if @dose.save
        # For the AJAX requests
        respond_to do |format|
          format.html
          format.js
        end

      # In case there's an error saving the new dose
      else
        @review = Review.new
        render 'cocktails/show'
      end

    else
      update
    end
  end

  def update
    @dose = @cocktail.doses.find_by(ingredient_id: params["dose"]["ingredient_id"])
    @dose.update(dose_params)
  end

  def destroy
    @dose = Dose.find(params[:id])
    @dose.destroy

    # For the AJAX requests
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def dose_params
    params.require(:dose).permit(:description, :ingredient_id)
  end

  def set_cocktail
    @cocktail = Cocktail.find(params[:cocktail_id])
  end
end
