class AdminsController < ApplicationController
	before_filter :authenticate_admin!
	def edit_info
		@admin = current_admin
	end

	def update
		@admin = Admin.find_by_id(params[:admin][:id])
		if @admin.update_attributes(params.require(:admin).permit([:login,:password,:password_confirmation,:name,:surname]))
			redirect_to root_path, success: 'Параметры обновлены'
		else
			render 'edit_info', alert: 'something wrong'
		end
	end
end
