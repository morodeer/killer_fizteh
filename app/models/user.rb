class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_validation :create_login_and_password
  devise :database_authenticatable,
         #:registerable,
         #:recoverable,
         :rememberable,
         :trackable,:validatable
  has_many :killers_cards, class_name: "Card", foreign_key: :owner_id, dependent: :destroy
  has_one :victims_card, class_name: "Card", foreign_key: :victim_id, dependent: :destroy


  has_many :victims, through: :killers_cards
  has_one :killer, through: :victims_card

  has_many :source_events, class_name: 'Event', foreign_key: 'source_id'
  has_many :target_events, class_name: 'Event', foreign_key: 'target_id'
  has_many :new_target_events, class_name: 'Event', foreign_key: 'new_target_id'

  has_attached_file :avatar, styles: {medium: ['450x300', :jpg], thumb: ['150x100#', :jpg]},
                    url: "/system/avatars/:hash.:extension", hash_secret: 'killerfiztehbymorodeer',
                    default_url: "/system/avatars/:style/missing.jpg"

  def target
		victims.where(dead: nil).first
  end

  def die
		self.update_attribute(:dead,true)
  end

	def kill(user,password,method)
		if user.killing_word == password && self.target.id == user.id
			user.die
			user.victims_card.kill
			user.killers_cards.each do |card|
				Event.create(event_type:'card_transfer',source:self,target:user,card:card,method:method)
			end
			killers_cards << user.killers_cards
			Event.create(event_type:'murder',source:self,target:user,method:method, new_target: self.target, card_count: self.killers_cards.count)

		end
	end

	def full_name
		"#{name} #{surname}"
	end

  def email_required?
		false
  end

  def email_changed?
		false
  end

  def update_killing_word
	  self.killing_word = SecureRandom.base64(6)
	  self.save
  end

  def update_login_and_password
	  self.login = (0..8).map{ ('a'..'z').to_a[rand(26)]}.join
	  self.password = (0..8).map{ ('a'..'z').to_a[rand(26)]}.join
	  self.password_confirmation = self.password
	  self.temp_password = self.password
		self.save
  end

  def avatar_thumb
    avatar.url(:thumb)
  end

  def killers_cards_count
    killers_cards.count
  end

	private
		def create_login_and_password
      if self.login == ""

        self.login = (0..8).map{ ('a'..'z').to_a[rand(26)]}.join
        self.password = (0..8).map{ ('a'..'z').to_a[rand(26)]}.join
        self.password_confirmation = self.password
        self.temp_password = self.password
  			self.killing_word = SecureRandom.base64(6)
      end

      #self.save
		end
end
