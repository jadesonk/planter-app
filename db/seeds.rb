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

tags = ['sun requirement', 'edible', 'beginner friendly', 'low maintenance', 'high maintenance']
puts "Destroy All Tags"
Tag.destroy_all

puts
puts "Creating listing tags"
tags.each do |tag|
  Tag.create!(name: tag)
  puts "Created [#{tag}] Tag"
end
puts

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
    listing_type: (0..2).to_a.sample,
    status: 0,
    expiry_date: Date.today - 10 + (8..45).to_a.sample
  }

  new_listing = Listing.new(listing_attr)
  # add random tags
  puts "randomizing tags for listings"
  (0..3).to_a.sample.times do
    random_tag = Tag.offset(rand(Tag.count)).first
    unless new_listing.tags.include? random_tag
      new_listing.tags << random_tag
      puts "added [#{random_tag.name}] to listing - #{title}"
    end
  end

  # scrape and upload imgs to cloudinary for each listing
  puts "Add images to listing"
  img_url = "https://www.gardeneur.com/?category=all&transaction_type=all&view=list"
  img_doc = Nokogiri::HTML(open(img_url).read)
  (0..5).to_a.sample.times do
    random_img = img_doc.search('.home-list-image').to_a.sample
    random_img_url = random_img.attributes["src"].value
    random_img_slug = random_img.attributes["alt"].value.downcase.split.join("-")
    random_img_file = URI.open(random_img_url)
    new_listing.photos.attach(io: random_img_file, filename: "#{random_img_slug}.jpeg", content_type: 'image/jpeg')
  end

  # get a random user
  random_user = User.offset(rand(User.count)).first
  puts "assigning [#{random_user.email}] to listing - #{title}"
  # assign user to new listing
  new_listing.user = random_user
  new_listing.save
end

puts "END SEED"
