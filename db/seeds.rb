# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create!(name: "Example User",
                    email: "ex@example.com",
                    password: "password",
                    password_confirmation: "password")

c_date = Date.today
user.create_profile!(city: "Chicago",
                     state: "IL",
                     country: "USA",
                     time_zone: "Central Time (US & Canada)",
                     birthday: Date.new(c_date.year - 21,
                                        c_date.month,
                                        c_date.day),
                     gender: nil)

genders = ["Male", "Female", "Other", nil]
99.times do |n|
  user = User.create!(name: Faker::Name.name,
                      email: "ex-#{n}@example.com",
                      password: "password",
                      password_confirmation: "password")

  user.create_profile!(city: Faker::Address.city,
                       state: Faker::Address.state_abbr,
                       country: "USA",
                       time_zone: "Eastern Time (US & Canada)",
                       birthday: Faker::Date.birthday,
                       gender: genders[n % genders.length])
end

User.all.each do |user|
  5.times do
    n = rand(0..98)
    relevant_id = User.find_by(email: "ex-#{n}@example.com").id
    # Some requests will be invalid, and will not be saved
    user.sent_friend_requests.create(receiver_id: relevant_id)
  end
end

User.all.each do |user|
  5.times do
    n = rand(0..98)
    other_user = User.find_by(email: "ex-#{n}@example.com")

    no_sent_requests = !user.sent_friend_requests
                            .where(receiver_id: other_user.id).exists?
    no_received_requests = !other_user.sent_friend_requests
                                      .where(receiver_id: user.id).exists?

    if no_sent_requests && no_received_requests
      # Some friendships will be invalid, and will not be saved
      user.friendships.create(passive_friend_id: other_user.id)
      other_user.friendships.create(passive_friend_id: user.id)
    end
  end
end
