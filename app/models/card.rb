class Card < ActiveRecord::Base
	belongs_to :killer, class_name: "User"
	belongs_to :victim, class_name: "User"
	belongs_to :owner, class_name: "User"
	has_many :events
	#before_create :set_owner

	def kill
		self.update_attribute(:killed,true)
	end

	def revive
		self.update_attribute(:killed,false)
	end

	private
		def set_owner
			self.owner_id = self.killer_id
		end
end
