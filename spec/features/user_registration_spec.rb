require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do
  scenario "has valid user info and valid CC info" do
    visit register_path
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"

    expect(page).to have_content("Thank you for registering with MyFlix. Please sign in now.")
  end

  scenario "has valid user info and invalid card" do
    visit register_path
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid")
  end

  scenario "has valid user info and declined CC" do
    visit register_path
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"

    expect(page).to have_content("Your card was declined.")
  end

  scenario "has invalid user info and declined CC" do
    visit register_path
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"

    expect(page).to have_content("can't be blank")
  end

  scenario "has invalid user info and invalid CC info" do
    visit register_path
    fill_in_invalid_user_info
    fill_in_invalid_card

    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid")
  end

  scenario "has invalid user info and valid CC info" do
    visit register_path
    fill_in_invalid_user_info
    fill_in_valid_card

    click_button "Sign Up"

    expect(page).to have_content("can't be blank")
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "testingthisemail@test.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Jose Doe"
  end

  def fill_in_invalid_user_info
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Jose Doe"
  end

  def fill_in_valid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2015", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2015", from: "date_year"
  end


  def fill_in_invalid_card
    fill_in "Credit Card Number", with: "123"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2015", from: "date_year"
  end
end