# frozen_string_literal: true

require "rails_helper"
require "features/general"
require "features/sign_in"

include Features

feature "highlights" do
  background do
    @user1 = create(:user, email: "user@example.com", password: "123456")
    @author1 = create(:author, user: @user1)
    @source1 = create(:source, user: @user1, authors: [@author1])
    @user2 = create(:user, email: "user2@example.com", password: "123456")
    # TODO: This should fail (author doesn't belong to user).
    @source2 = create(:source, user: @user2, authors: [@author1])
    @highlight1 = create(:highlight, user: @user1, source: @source1, favorite: true)
    @highlight2 = create(:highlight, user: @user1, source: @source1)
    @highlight3 = create(:highlight, user: @user1, source: @source1, published: false)
  end

  scenario "adds new highlight" do
    sign_in_as("user@example.com")
    visit highlights_path

    click_on "New highlight"
    fill_in "highlight[highlight]", with: "My highlight"
    fill_in "highlight[note]", with: "My note"
    click_on "Save Highlight"

    expect(page).to have_css("table.highlights td", text: "My highlight")
  end

  scenario "favorites highlight" do
    sign_in_as("user@example.com")
    visit highlights_path
    expect(page).to have_css "table.highlights tbody tr", count: 2

    check "Favorite"
    click_on "Filter"
    expect(page).to have_css "table.highlights tbody tr", count: 1

    uncheck "Favorite"
    click_on "Filter"
    click_link "favorite-" + @highlight2.id.to_s
    visit highlights_path
    check "Favorite"
    click_on "Filter"

    expect(page).to have_css "table.highlights tbody tr", count: 2
  end

  scenario "unfavorites highlight" do
    sign_in_as("user@example.com")
    visit highlights_path
    expect(page).to have_css "table.highlights tbody tr", count: 2

    check "Favorite"
    click_on "Filter"
    expect(page).to have_css "table.highlights tbody tr", count: 1

    uncheck "Favorite"
    click_on "Filter"
    click_link "favorite-" + @highlight1.id.to_s
    visit highlights_path
    check "Favorite"
    click_on "Filter"

    expect(page).to have_css "table.highlights tbody tr", count: 0
  end

  scenario "edits highlight" do
    sign_in_as("user@example.com")
    visit highlights_path

    find("#edit-highlight-" + @highlight1.id.to_s).click
    fill_in "highlight[highlight]", with: "Edited highlight"
    fill_in "highlight[note]", with: "Edited note"
    click_on "Save Highlight"

    expect(page).to have_css("table.highlights td", text: "Edited highlight")
    expect(page).to have_css("table.highlights td", text: "Edited note")
  end

  scenario "filters highlights" do
    pending "get working with chosen"
    sign_in_as("user@example.com")
    create_highlight("Tag1, Tag2")
    create_highlight("Tag1")
    visit highlights_path
    # select_from_chosen 'Tag1', :from => 'tag'
    expect(page).to have_css "#tag_chosen"
  end

  scenario "unpublishes highlight" do
    sign_in_as("user@example.com")
    visit highlights_path
    expect(page).to have_css "table.highlights tbody tr", count: 2

    click_on "See Deleted Highlights"
    expect(page).to have_css "table.highlights tbody tr", count: 1

    visit highlights_path
    click_link "publish-" + @highlight1.id.to_s
    visit highlights_path
    expect(page).to have_css "table.highlights tbody tr", count: 1

    click_on "See Deleted Highlights"
    expect(page).to have_css "table.highlights tbody tr", count: 2
  end
end
