require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    comedies = Category.create(name: "comedies")
    monk = Fabricate(:video, title: "Monk")
    south_park = Fabricate(:video, title: "South Park")
    futurama = Fabricate(:video, title: "Futurama")
    monk.categories << comedies
    south_park.categories << comedies
    futurama.categories << comedies

    sign_in
    find("a[href='/videos/#{monk.id}']").click
    page.should have_content(monk.title)

    click_link "+ My Queue"
    page.should have_content(monk.title)

    visit video_path(monk)
    page.should_not have_content "+ My Queue"

    visit home_path
    find("a[href='/videos/#{south_park.id}']").click
    click_link "+ My Queue"
    visit home_path
    find("a[href='/videos/#{futurama.id}']").click    
    click_link "+ My Queue"

    set_video_position(south_park, 1)
    set_video_position(monk, 3)
    set_video_position(futurama, 2)

    click_button "Update Instant Queue"

    expect_video_position(south_park, 1)
    expect_video_position(monk, 3)
    expect_video_position(futurama, 2)
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
  expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end