Fabricator(:review) do
  rating Faker::Number.between(1, 5)
  text   Faker::Lorem.words(20).join(' ')
  video
  user
end
