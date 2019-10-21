# frozen_string_literal: true

module Features
  def create_user(email)
    create(:user, email: email, password: "123456")
  end

  def sign_in
    create_user("person@example.com")
    sign_in_as("person@example.com")
  end

  def sign_in_as(email)
    visit root_path
    fill_in "Email", with: email
    fill_in "Password", with: "123456"
    click_on "Log in"
  end

  def sign_up_as(email)
    visit root_path
    click_on "Sign up"
    fill_in "Email", with: email
    fill_in "Password", with: "123456"
    click_on "Sign up"
  end
end
