require 'spec_helper'

feature 'follow and unfollow users' do
  scenario 'following a user' do
    comedies = Fabricate(:category, name: 'Comedies')
    video = Fabricate(:video, category: comedies)
    alice = Fabricate(:user, full_name: 'Alice')
    review = Fabricate(:review, user: alice, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link alice.full_name
    click_link 'Follow'
    expect(page).to have_content("You are now following #{alice.full_name}")

    visit people_path
    expect(page).to have_content(alice.full_name)

    unfollow(alice)
    expect(page).to have_content("You have unfollowed #{alice.full_name}")

    confirm_you_are_not_following(alice)
  end

  def unfollow(user)
    within(:xpath, "//tr[contains(., '#{user.full_name}')]") do
      find("a[data-method='delete']").click
    end
  end

  def confirm_you_are_not_following(user)
    visit people_path
    expect(page).not_to have_content(user.full_name)
  end
end

