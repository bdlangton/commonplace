# frozen_string_literal: true

require "rails_helper"
require "features/general"
require "features/sign_in"

include Features

feature "authors" do
  background do
    @user1 = create(:user, email: "user@example.com", password: "123456")
    @author1 = create(:author, name: "Mr Author1", user: @user1)
    @author2 = create(:author, name: "Mr Author2", user: @user1)
    @source1 = create(:source, title: "Source 1", user: @user1, authors: [@author1])
    @highlight1 = create(:highlight, user: @user1, source: @source1, favorite: true)
    @highlight2 = create(:highlight, user: @user1, source: @source1, favorite: false)
  end

  scenario "adds new author" do
    sign_in_as("user@example.com")
    visit authors_path

    click_on "New author"
    fill_in "author[name]", with: "Mr Author"
    fill_in "author[all_tags]", with: "science"
    click_on "Save Author"

    expect(page).to have_css("h1", text: "Mr Author")
    visit authors_path
    expect(page).to have_css("table.authors td.author", text: "Mr Author")
  end

  scenario "adds invalid new author" do
    sign_in_as("user@example.com")
    visit authors_path

    click_on "New author"
    click_on "Save Author"

    expect(page).to have_css("li", text: "Name is required")
  end

  scenario "views author" do
    sign_in_as("user@example.com")
    visit authors_path

    click_on "Mr Author1"
    expect(page).to have_css("table.sources td.title", text: "Source 1")
    expect(page).to have_css("p.favorites-highlights", text: "1 / 2")
  end

  scenario "edits author" do
    sign_in_as("user@example.com")
    visit authors_path

    find("#edit-author-" + @author1.id.to_s).click
    fill_in "author[name]", with: "Edited author"
    fill_in "author[all_tags]", with: "Edited tag"
    click_on "Save Author"

    expect(page).to have_css("h1", text: "Edited author")
    expect(page).to have_css("p", text: "Edited tag")
    visit authors_path
    expect(page).to have_css("table.authors td.author", text: "Edited author")
  end

  scenario "edits author with autocomplete tags" do
    pending "get working with autocomplete"
    sign_in_as("user@example.com")
    visit authors_path

    find("#edit-author-" + @author1.id.to_s).click
    expect(page).to have_css("no")
  end

  scenario "edits invalid author" do
    sign_in_as("user@example.com")
    visit authors_path

    find("#edit-author-" + @author1.id.to_s).click
    fill_in "author[name]", with: ""
    fill_in "author[all_tags]", with: "Edited tag"
    click_on "Save Author"

    expect(page).to have_css("li", text: "Name is required")
  end

  scenario "deletes author" do
    pending "have to use selenium but it is running on dev, not test"
    # Capybara.current_driver = :selenium
    # Capybara.server = :puma
    sign_in_as("user@example.com")
    visit authors_path

    accept_alert do
      find("#delete-author-" + @author1.id.to_s).click
    end
  end

  scenario "sort by" do
    sign_in_as("user@example.com")
    visit authors_path

    select "Name", from: "sort"
    click_on "Filter"
    expect(page).to have_xpath('//table/tbody/tr[1]/td[@class="author"]', text: "Mr Author1")

    select "Last Added", from: "sort"
    click_on "Filter"
    expect(page).to have_xpath('//table/tbody/tr[1]/td[@class="author"]', text: "Mr Author2")
  end
end
