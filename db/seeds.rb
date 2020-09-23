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

User.create!(
  email: 'jade@test.com',
  password: '123123'
)

10.times do
  User.create!(
    email: Faker::Name.unique.first_name + '@test.com',
    password: '123123'
  )
end

puts "Create Listings for users"
url = "https://plantswap.org/listings/page/4/"
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.geodir-category-list-view > li').each do |element|
  title = element.search('.geodir-entry-title a').text.strip
  href_url = element.search('.geodir-field-post_content a').attribute('href').value
  description_doc = Nokogiri::HTML(open(href_url).read)
  description = description_doc.search('.geodir-field-post_content p').text.strip

  listing_attr = {
    title: title,
    description: description,
    listing_type: (0..2).to_a.sample
  }

  new_listing = Listing.new(listing_attr)
  # get a random user
  random_user = User.offset(rand(User.count)).first
  # assign user to new listing
  new_listing.user = random_user
  new_listing.save
end

puts "END SEED"
