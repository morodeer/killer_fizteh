class Event < ActiveRecord::Base
	belongs_to :source, class_name: "User", inverse_of: :source_events
	belongs_to :target, class_name: "User", inverse_of: :target_events
	belongs_to :card, class_name: "Card"
	belongs_to :new_target, class_name: "User", inverse_of: :new_target_events

end
