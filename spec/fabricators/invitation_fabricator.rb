Fabricator(:invitation) do
  recipient_name { Faker::Name.name }
  recipient_email { Faker::Internet.safe_email }
  inviter { Fabricate(:user) }
  message { Faker::Lorem.sentence }
end

