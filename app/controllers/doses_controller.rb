class DosesController < ApplicationController
  def create
    @cocktail = Cocktail.find(params[:cocktail_id])

    unless @cocktail.doses.find_by(ingredient_id: params["dose"]["ingredient_id"]).nil?
      update

    else
      @dose = Dose.new(dose_params)
      @dose.cocktail = @cocktail

      if @dose.save
        redirect_to cocktail_path(@cocktail, anchor: "ingredients-list")
      else
        @review = Review.new
        render 'cocktails/show'
      end
    end
  end

  def update
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = @cocktail.doses.find_by(ingredient_id: params["dose"]["ingredient_id"])
    @dose.update(dose_params)

    redirect_to cocktail_path(@cocktail, anchor: "ingredients-list")
  end

  def destroy
    @dose = Dose.find(params[:id])
    @dose.destroy

    redirect_to cocktail_path(@dose.cocktail, anchor: "ingredients-list")
  end

  private

  def dose_params
    params.require(:dose).permit(:description, :ingredient_id)
  end
end
