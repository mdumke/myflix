Fabricator(:video) do
  title       Faker::Commerce.product_name
  description Faker::Hacker.say_something_smart
end

