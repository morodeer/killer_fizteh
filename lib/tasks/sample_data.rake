# -*- encoding : utf-8 -*-
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

	  User.destroy_all
	  Card.destroy_all
	  Event.destroy_all

	  ActiveRecord::Base.connection.execute(
			  "ALTER SEQUENCE users_id_seq RESTART WITH 1"
	  )

    make_users
    make_cards


  end

  def make_users

    5.times do |n|
      name = Faker::Name.first_name
      surname = Faker::Name.last_name

      User.create!(
                    name:name,
                   surname:surname,
      )
    end
  end

  def make_cards
    (1..4).each do |n|
	    puts "#{n} : #{User.find_by_id(n).full_name}"
	    Card.create!(killer:User.find_by_id(n),victim:User.find_by_id(n+1))
    end
    Card.create!(killer:User.find_by_id(5),victim:User.find_by_id(1))
  end
end