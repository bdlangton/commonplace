require 'rails_helper'
require 'features/general'
require 'features/sign_in'

include Features

feature "tags" do
  background do
    @user1 = create(:user, email: 'user@example.com', password: '123456')
    @tag1 = create(:tag, user: @user1)
    @user2 = create(:user, email: 'user2@example.com', password: '123456')
    @tag2 = create(:tag, user: @user2)
  end

  scenario "adds new tag" do
    sign_in_as('user@example.com')
    visit tags_path

    click_on 'New tag'
    fill_in 'tag[title]', with: 'My tag'
    click_on 'Save Tag'

    expect(page).to have_css('h1', text: 'My tag')
    visit tags_path
    expect(page).to have_css('table.tags td.title', text: 'My tag')
  end

  scenario "edits tag" do
    sign_in_as('user@example.com')
    visit tags_path

    find('#edit-tag-' + @tag1.id.to_s).click
    fill_in 'tag[title]', with: 'Edited tag'
    click_on 'Save Tag'

    expect(page).to have_css('h1', text: 'Edited tag')
    visit tags_path
    expect(page).to have_css('table.tags td.title', text: 'Edited tag')
  end

  scenario "deletes tag" do
    pending "have to use selenium but it is running on dev, not test"
    # Capybara.current_driver = :selenium
    # Capybara.server = :puma
    sign_in_as('user@example.com')
    visit tags_path

    accept_alert do
      find('#delete-tag-' + @tag1.id.to_s).click
    end
  end
end
