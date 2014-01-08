class EventsController < ApplicationController
	#before_filter :authenticate_admin!
	def index
		@events = Event.where(event_type:'murder').reorder('created_at DESC').paginate(page: params[:page])
	end
end
