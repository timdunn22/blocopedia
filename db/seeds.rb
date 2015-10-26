# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'
5.times do
  user = User.new(
    name:     Faker::Name.name,
    email:    Faker::Internet.email,
    password: Faker::Lorem.characters(10)
  )
  user.skip_confirmation!
  user.save!
end
users = User.all
20.times do
  Wiki.create!(
    title:         Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph,
    user: users.sample,

  )
end
wikis = Wiki.all
20.times do
  Collaborator.create!(
  user: users.sample,
  wiki: wikis.sample
  )

end
admin = User.new(
  name:     'Admin User',
  email:    'admin@example.com',
  password: 'helloworld',
  role:     'admin'
)
admin.skip_confirmation!
admin.save!
puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
