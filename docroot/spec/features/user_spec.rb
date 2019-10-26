# frozen_string_literal: true

require "rails_helper"
require "features/general"
require "features/sign_in"

include Features

feature "user" do
  background do
    @user1 = create(:user, email: "user@example.com", password: "123456")
    @author1 = create(:author, user: @user1)
    @source1 = create(:source, user: @user1, authors: [@author1])
    @user2 = create(:user)
    @author2 = create(:author, user: @user2)
    @source2 = create(:source, user: @user2, authors: [@author2])
    @highlight1 = create(:highlight, user: @user1, source: @source1)
    @highlight2 = create(:highlight, user: @user1, source: @source1, favorite: true)
  end

  scenario "is anonymous" do
    visit root_path

    expect(page).to have_css "h2", text: "Log in"
    expect(page).to have_css ".flash.alert", text: "You need to sign in or sign up before continuing."
  end

  scenario "logs in" do
    sign_in_as("user@example.com")
    has_main_menu
  end

  scenario "invalid log in" do
    sign_in_as("user2@example.com")

    expect(page).to have_content "Invalid Email or password."
  end

  scenario "signs up" do
    sign_up_as("new-user@example.com")
    # has_main_menu
  end

  scenario "checks highlights" do
    sign_in_as("user@example.com")
    visit highlights_path

    expect(page).to have_css ".badge-primary", text: "New highlight"
    expect(page).to have_css ".badge-secondary", text: "See Deleted Highlights"
    expect(page).to have_css "table.highlights tbody tr", count: 2
  end

  scenario "checks favorites" do
    sign_in_as("user@example.com")
    visit favorites_path

    expect(page).to have_css ".badge-primary", text: "New highlight"
    expect(page).to have_css "table.highlights tbody tr", count: 1
  end

  scenario "checks tags" do
    sign_in_as("user@example.com")
    visit tags_path

    expect(page).to have_css ".badge-primary", text: "New tag"
    expect(page).to have_css "table.tags tbody tr", count: 0
  end

  scenario "checks sources" do
    sign_in_as("user@example.com")
    visit sources_path

    expect(page).to have_css ".badge-primary", text: "New source"
    expect(page).to have_css "table.sources tbody tr", count: 1
  end
end
