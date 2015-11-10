require 'spec_helper'

feature 'reorder queue' do
  scenario 'adding video to the queue' do
    comedies = Fabricate(:category, name: 'Comedies')
    video1 = Fabricate(:video, category: comedies)
    video2 = Fabricate(:video, category: comedies)
    video3 = Fabricate(:video, category: comedies)

    sign_in

    add_video_to_my_queue(video1)
    expect_video_to_be_in_queue(video1)

    visit video_path(video1)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_my_queue(video2)
    add_video_to_my_queue(video3)

    set_queue_position(video1, 3)
    set_queue_position(video2, 1)
    set_queue_position(video3, 2)
    update_queue

    expect_queue_position(video1, 3)
    expect_queue_position(video2, 1)
    expect_queue_position(video3, 2)
  end

  def add_video_to_my_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link '+ My Queue'
  end

  def set_queue_position(video, position)
    within(:xpath, "//tr[contains(., '#{video.title}')]") do
      fill_in 'queue[][position]', with: position
    end
  end

  def expect_queue_position(video, position)
    query = "//tr[contains(., '#{video.title}')]//input[@type='text']"
    expect(find(:xpath, query).value).to eq(position.to_s)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content video.title
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content link_text
  end

  def update_queue
    click_button 'Update Instant Queue'
  end
end

