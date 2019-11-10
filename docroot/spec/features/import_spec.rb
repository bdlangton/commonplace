# frozen_string_literal: true

require "rails_helper"
require "features/general"
require "features/sign_in"

include Features

feature "import" do
  background do
    @user1 = create(:user, email: "user@example.com", password: "123456")
  end

  scenario "imports from Kindle" do
    pending "get working"
    sign_in_as("user@example.com")
    visit import_path

    expect(page).to have_css("no")
  end

  scenario "uploads JSON file" do
    sign_in_as("user@example.com")
    visit import_path

    expect(page).to have_css("h1", text: "Import Highlights")
    expect(page).to have_css("h1", text: "Upload JSON File")

    attach_file("file", File.join(Rails.root, "/spec/support/Sapiens.json"))
    click_button("Upload")

    expect(page).to have_css("div.flash.notice", text: "Upload finished. 1 authors added, 1 books added, 74 highlights added, and 0 highlights updated.")
    expect(page).to have_css("h1", text: "Highlights")
  end

  scenario "uploads JSON file then updated JSON file" do
    sign_in_as("user@example.com")
    visit import_path

    attach_file("file", File.join(Rails.root, "/spec/support/Atrocities-1.json"))
    click_button("Upload")

    expect(page).to have_css("div.flash.notice", text: "Upload finished. 2 authors added, 1 books added, 84 highlights added, and 0 highlights updated.")
    expect(page).to have_css("h1", text: "Highlights")

    # Upload the updated version of the file. This has one highlight with a note
    # added and one with a kindle URL added.
    visit import_path
    attach_file("file", File.join(Rails.root, "/spec/support/Atrocities-2.json"))
    click_button("Upload")

    expect(page).to have_css("div.flash.notice", text: "Upload finished. 0 authors added, 0 books added, 0 highlights added, and 2 highlights updated.")
    expect(page).to have_css("h1", text: "Highlights")
  end

  scenario "uploads invalid JSON file" do
    sign_in_as("user@example.com")
    visit import_path

    attach_file("file", File.join(Rails.root, "/spec/support/invalid.json"))
    click_button("Upload")

    # Still on import page with a flash alert.
    expect(page).to have_css("div.flash.alert", text: "There was a JSON parse error. Please confirm that your file is valid JSON")
    expect(page).to have_css("h1", text: "Import Highlights")
    expect(page).to have_css("h1", text: "Upload JSON File")
  end
end
