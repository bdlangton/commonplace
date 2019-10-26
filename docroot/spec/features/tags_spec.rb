# frozen_string_literal: true

require "rails_helper"
require "features/general"
require "features/sign_in"

include Features

feature "tags" do
  background do
    @user1 = create(:user, email: "user@example.com", password: "123456")
    @tag1 = create(:tag, user: @user1, title: "Tag1")
    @user2 = create(:user, email: "user2@example.com", password: "123456")
    @tag2 = create(:tag, user: @user2, title: "Tag2")
  end

  scenario "adds new tag" do
    sign_in_as("user@example.com")
    visit tags_path

    click_on "New tag"
    fill_in "tag[title]", with: "My tag"
    click_on "Save Tag"

    expect(page).to have_css("h1", text: "My tag")
    visit tags_path
    expect(page).to have_css("table.tags td.title", text: "My tag")
  end

  scenario "adds invalid new tag" do
    sign_in_as("user@example.com")
    visit tags_path

    click_on "New tag"
    click_on "Save Tag"

    expect(page).to have_css("li", text: "Title is required")
  end

  scenario "edits tag" do
    sign_in_as("user@example.com")
    visit tags_path

    find("#edit-tag-" + @tag1.id.to_s).click
    fill_in "tag[title]", with: "Edited tag"
    click_on "Save Tag"

    expect(page).to have_css("h1", text: "Edited tag")
    visit tags_path
    expect(page).to have_css("table.tags td.title", text: "Edited tag")
  end

  scenario "deletes tag" do
    pending "have to use selenium but it is running on dev, not test"
    # Capybara.current_driver = :selenium
    # Capybara.server = :puma
    sign_in_as("user@example.com")
    visit tags_path

    accept_alert do
      find("#delete-tag-" + @tag1.id.to_s).click
    end
  end

  scenario "merges two tags" do
    pending "get working with chosen"
    sign_in_as("user@example.com")
    @highlight1 = create_highlight("Tag1")
    @highlight2 = create_highlight("Tag2")

    visit tags_path
    expect(page).to have_css "table.tags tbody tr", count: 2

    click_on "Merge tags"
    expect(page).to have_css("h1", text: "Merge Tags")
    select_from_chosen "Tag1", from: "tag_to_use"
    select_from_chosen "Tag2", from: "tags_to_merge"
    click_on "Merge Tags"

    visit tags_path
    expect(page).to have_css "table.tags tbody tr", count: 1
  end
end
