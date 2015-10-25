Fabricator(:queue_item) do
  queue_position { Faker::Number.between(1, 5) }
end
