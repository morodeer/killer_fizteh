class UsersPdf < Prawn::Document

	def new_position
		@iter = @iter + 1
		(@iter-1)%3
	end

	def page_layout
		'landscape'
	end

	def initialize(users)

		line_width = 2
		font_families.update("BookAntiqua" => {
				normal: "#{Rails.root}/public/fonts/bkant.ttf"
		})
		#font "BookAntiqua"


		puts('####################INIT PDF')
		super()
		start_new_page(layout: :landscape)
		@iter = 0
		font('BookAntiqua') do

			users.each do |user|
				block(user,new_position)
				if (@iter % 6) == 0
					start_new_page
				end
			end
			 start_new_page
			@iter = 0
			users.each do |user|
				login_block(user,new_position)
				if (@iter % 9) == 0
					start_new_page
				end
			end
		end

	end

	def block(user,position)
		if position != 0
			puts "iter: #{@iter}, position: #{position}"
			move_up 2*block_height + text_height
			bounding_box([(block_width+5)*position,cursor],width:block_width,height: (2 * block_height) + text_height) do
				text user.id.to_s
				killers_block(user)
				victims_block(user)
				#transparent(0.5) {stroke_bounds}
			end
		else
			move_down 6
			bounding_box([0,cursor],width:block_width,height: (2 * block_height) + text_height) do
				text user.id.to_s
				killers_block(user)
				victims_block(user)
				#transparent(0.5) {stroke_bounds}
			end
		end
	end

	def login_block(user,position)
		if position != 0
			move_up block_height + text_height
			bounding_box([(block_width+5)*position,cursor],width:block_width,height: block_height + text_height) do
				text user.id.to_s
				login_inner_block(user)
			end
		else
			move_down 6
			bounding_box([0,cursor],width:block_width,height: block_height + text_height) do
			text user.id.to_s
			login_inner_block(user)
		end
		end
	end

	def killers_block(user)
		bounding_box([0,cursor],width:block_width,height:block_height) do
			logopath=Rails.root.join('app','assets','images','killers_card.png')
			image logopath, width: inner_width, at: [offset_left,block_height - offset_top]
			move_cursor_to block_height
			text "#{user.target.name}\n#{user.target.surname}", align: :center, valign: :center, size: 18
			transparent(0.5) {stroke_bounds}
		end
	end

	def login_inner_block(user)
		bounding_box([0,cursor],width:block_width,height:block_height) do
			path = Rails.root.join('app','assets','images','login_password.png')
			image path, width: inner_width, at: [offset_left, block_height - offset_top]
			move_cursor_to block_height - 4.75*offset_top
			text user.login, align: :center, size: 16
			move_cursor_to block_height - 9.75*offset_top
			text user.temp_password, align: :center, size: 16
			transparent(0.5) {stroke_bounds}

		end
	end

	def victims_block(user)
		rotate(180, origin: [ block_width/2 , block_height/2 + 1 ]) do
			bounding_box([0,cursor],width:block_width,height:block_height) do
				path = Rails.root.join('app','assets','images','victims_card.png')
				image path, width: inner_width, at: [offset_left,block_height - offset_top]
				move_cursor_to block_height - 4.5*offset_top

				text "#{user.killing_word}", align: :center, size: 16
				transparent(0.5) {stroke_bounds}
			end
		end

	end

	def block_width
		(80.mm.to_inch * 72).to_i
	end

	def block_height
		(42.5.mm.to_inch * 72).to_i
	end

	def inner_width
		(75.mm.to_inch * 72).to_i
	end

	def offset_left
		(2.5.mm.to_inch * 72).to_i
	end

	def offset_top
		(2.5.mm.to_inch * 72).to_i
	end

	def text_height
		(5.mm.to_inch*72).to_i
	end
end