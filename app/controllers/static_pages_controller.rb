class StaticPagesController < ApplicationController
	def home

      render 'events/index'

		  #if user_signed_in?
			#  @user = current_user
      #  @target = @user.target
      #  @events = Event.where(event_type:'murder',source_id:@user.id)
      #  @killers_card = Card.where(owner: @user, victim: @target)
			#  #unless @user.dead
			#		#if @user.target.present
			#	 #   @target = current_user.target
			#	 #   @target.killing_word = ''
			#		#end
			#  #end

			#  render 'users/show'
      #else
      #  render 'rules'
      #end

	end

	def my_page
	end

	def rules
		#render 'home'
	end

end
