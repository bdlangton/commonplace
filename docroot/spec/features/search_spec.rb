# frozen_string_literal: true

require "rails_helper"
require "features/general"
require "features/sign_in"

include Features

feature "search" do
  background do
    @user1 = create(:user, email: "user@example.com", password: "123456")
    @author1 = create(:author, name: "My author", user: @user1)
    @author2 = create(:author, name: "Another author", user: @user1)
    @source1 = create(:source, title: "Source 1", user: @user1, authors: [@author1])
    @source2 = create(:source, title: "Another source", user: @user1, authors: [@author2])
    @tag1 = create(:tag, user: @user1, title: "A random tag")
    @tag2 = create(:tag, user: @user1, title: "My best tag")
    @highlight1 = create(:highlight, highlight: "This is a highlight", note: "This is my note", user: @user1, source: @source1, tags: [@tag1], favorite: true)
    @highlight2 = create(:highlight, highlight: "random highlight", note: "random note", user: @user1, tags: [@tag1, @tag2], source: @source1)
    @highlight3 = create(:highlight, highlight: "Unpublished highlight", note: "Unpublished note", user: @user1, source: @source1, tags: [@tag2], published: false)
    @user2 = create(:user, email: "user2@example.com", password: "123456")
    @author3 = create(:author, name: "User 2 author", user: @user2)
    @source3 = create(:source, title: "My Source", user: @user2, authors: [@author3])
    @tag3 = create(:tag, user: @user2, title: "My best tag")
  end

  scenario "search all" do
    sign_in_as("user@example.com")

    fill_in "search", with: "my"
    click_on "Search"

    expect(page).to have_css("table.highlights tbody tr", count: 1)
    expect(page).to_not have_css("table.sources")
    expect(page).to have_css("table.authors tbody tr", count: 1)
    expect(page).to have_css("table.tags tbody tr", count: 1)

    fill_in "search", with: "random"
    click_on "Search"

    expect(page).to have_css("table.highlights tbody tr", count: 1)
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.authors")
    expect(page).to have_css("table.tags tbody tr", count: 1)

    fill_in "search", with: "noresult"
    click_on "Search"

    expect(page).to have_css("div.container", text: "No results found.")

    fill_in "search", with: ""
    click_on "Search"

    expect(page).to have_css("div.container", text: "Please enter a search term.")
  end

  scenario "search highlights" do
    sign_in_as("user@example.com")

    fill_in "search", with: "highlight"
    select "Highlights", from: "model"
    click_on "Search"

    expect(page).to have_css("table.highlights tbody tr", count: 2)
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.authors")
    expect(page).to_not have_css("table.tags")

    fill_in "search", with: "note"
    select "Highlights", from: "model"
    click_on "Search"

    expect(page).to have_css("table.highlights tbody tr", count: 2)
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.authors")
    expect(page).to_not have_css("table.tags")
  end

  scenario "search sources" do
    sign_in_as("user@example.com")

    fill_in "search", with: "source"
    select "Sources", from: "model"
    click_on "Search"

    expect(page).to have_css("table.sources tbody tr", count: 2)
    expect(page).to_not have_css("table.highlights")
    expect(page).to_not have_css("table.authors")
    expect(page).to_not have_css("table.tags")

    fill_in "search", with: "another"
    select "Sources", from: "model"
    click_on "Search"

    expect(page).to have_css("table.sources tbody tr", count: 1)
    expect(page).to_not have_css("table.highlights")
    expect(page).to_not have_css("table.authors")
    expect(page).to_not have_css("table.tags")
  end

  scenario "search authors" do
    sign_in_as("user@example.com")

    fill_in "search", with: "author"
    select "Authors", from: "model"
    click_on "Search"

    expect(page).to have_css("table.authors tbody tr", count: 2)
    expect(page).to_not have_css("table.highlights")
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.tags")

    fill_in "search", with: "another"
    select "Authors", from: "model"
    click_on "Search"

    expect(page).to have_css("table.authors tbody tr", count: 1)
    expect(page).to_not have_css("table.highlights")
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.tags")
  end

  scenario "search tags" do
    sign_in_as("user@example.com")

    fill_in "search", with: "tag"
    select "Tags", from: "model"
    click_on "Search"

    expect(page).to have_css("table.tags tbody tr", count: 2)
    expect(page).to_not have_css("table.highlights")
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.authors")

    fill_in "search", with: "random"
    select "Tags", from: "model"
    click_on "Search"

    expect(page).to have_css("table.tags tbody tr", count: 1)
    expect(page).to_not have_css("table.highlights")
    expect(page).to_not have_css("table.sources")
    expect(page).to_not have_css("table.authors")
  end
end
