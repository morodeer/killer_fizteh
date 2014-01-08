class CardsController < ApplicationController
	before_filter :authenticate_admin!
	def destroy
		@card = Card.find_by_id(params[:id])
		@user = @card.owner
		@card.destroy
		redirect_to @user
	end
end
