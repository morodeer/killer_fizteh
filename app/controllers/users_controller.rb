class UsersController < ApplicationController
	#before_filter :authenticate_admin!, only: [:new, :create, :destroy, :show, :index, :admin_kill, :edit,
  # :print_list, :set_target]
	#before_filter :authenticate_user!, only: [:edit_info]
  before_filter :stop_game, except: [:show, :index]

	def new
		@user = User.new
		@users = User.all
	end

	def create
		@user = User.create(params.require(:user).permit(:name,:surname,:avatar))
		if @user.save
			redirect_to new_user_path
		else
			render 'new'
		end
	end

	def destroy
		@user = User.find_by_id(params[:id])
		@user.destroy
		redirect_to users_path
	end

	def index
		#@users = User.paginate(page:params[:page])
		@users = User.all
	end

	def edit_info
		@user = current_user
	end

	def edit
		@user = User.find_by_id(params[:id])
	end

	def update

		if admin_signed_in?
			@user = User.find_by_id(params[:user][:id])
			if @user.update_attributes(params.require(:user).permit(:name,:surname,:login,:password,:password_confirmation,
        :avatar))
				redirect_to edit_user_path(@user), success: 'Параметры обновлены'
			else
				render 'edit'
			end
		elsif user_signed_in? and current_user.id.to_i == params[:user][:id].to_i
			@user = User.find_by_id(params[:user][:id])
			if @user.update_attributes(params.require(:user).permit(:login,:password,:password_confirmation))
				redirect_to new_user_session_path, success: 'Параметры обновлены'
			else
				render 'edit_info'
			end
		else
			redirect_to root_path, alert: 'У вас на это нет прав'
		end


	end

	def kill
		@target = User.find_by_id(params[:target][:id])
		@user = current_user
		if @user.target.id == @target.id
			puts 'starting killing'
			if @user.kill(@target,params[:target][:killing_word],'web')
				redirect_to root_path, success: 'Трупов всё больше, спасибо вам! )'
			else
				redirect_to root_path, alert: 'Промахнулись с жертвой или паролем. Брутфорс запрещен'
			end
		else
			redirect_to root_path, alert: 'У вас нет на это прав'
		end
	end

	def admin_kill
		@target = User.find_by_id(params[:target][:id])
		@user = User.find_by_id(params[:user][:id])
		if @user.target.id == @target.id
			puts 'starting killing'
			if @user.kill(@target,params[:target][:killing_word],'admin')
				redirect_to user_path(@user), success: 'Ок, убили.'
			else
				redirect_to user_path(@user), alert: 'С паролем не промахивайтесь =)'
			end
		end
	end

	def show
		@user = User.find_by_id(params[:id])
		@target = @user.target
		@events = Event.where(event_type:'murder',source_id:@user.id)
		@killers_card = Card.where(owner: @user, victim: @target)
	end

	def print_list
		@users = User.all
		respond_to do |format|
			format.html
			format.pdf do
				pdf = UsersPdf.new(@users)
				send_data pdf.render, filename: "userspdf.pdf",type:"application/pdf", disposition: "inline"
			end
		end
	end

	def set_target
		@user = User.find_by_id(params[:id])
		@target = User.find_by_id(params[:user][:id])
			Card.create(victim: @target, owner: @user)
		redirect_to @user
  end

  def revive
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(dead:nil)
      redirect_to @user
    else
      render 'show'
    end
  end

	private
		def is_current_user
			authenticate_user!
			unless params[:id].to_i == current_user.id.to_i
				redirect_to root_path, error: 'У вас на это нет прав'
			end
		end

    def stop_game
      redirect_to root_path
    end

end
