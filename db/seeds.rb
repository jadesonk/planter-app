# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'open-uri'
require 'nokogiri'

puts "START SEED"

puts "Destroy All Users"
User.destroy_all

puts "Create Users"
10.times do
  User.create!(
    email: Faker::Name.unique.first_name + '@test.com',
    password: '123123'
  )
end

puts "Create Listings for users"
url = "https://plantswap.org/listings/"
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.geodir-category-list-view > li').each do |element|
  title = element.search('.geodir-entry-title a').text.strip
  description = element.search('.geodir-field-post_content').text.strip
  listing_attr = {
    title: title,
    description: description
  }

  new_listing = Listing.new(listing_attr)
  # get a random user
  random_user = User.offset(rand(User.count)).first
  # assign user to new listing
  new_listing.user = random_user
  new_listing.save
end

puts "END SEED"
