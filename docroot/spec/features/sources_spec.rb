require 'rails_helper'
require 'features/general'
require 'features/sign_in'

include Features

feature "sources" do
  background do
    @user1 = create(:user, email: 'user@example.com', password: '123456')
    @source1 = create(:source, user: @user1, title: 'A source')
    @source2 = create(:source, user: @user1, source_type: 'Artist', title: 'Second source')
    @user2 = create(:user, email: 'user2@example.com', password: '123456')
    @source3 = create(:source, user: @user2)
  end

  scenario "adds new source" do
    sign_in_as('user@example.com')
    visit sources_path

    click_on "New source"
    fill_in "source[title]", with: "My source"
    fill_in "source[all_authors]", with: "Mr Author"
    fill_in "source[source_type]", with: "Book"
    fill_in "source[notes]", with: "My notes"
    click_on "Save Source"

    expect(page).to have_css('h1', text: 'My source')
    visit sources_path
    expect(page).to have_css('table.sources td.title', text: 'My source')
  end

  scenario "edits source" do
    sign_in_as('user@example.com')
    visit sources_path

    find('#edit-source-' + @source1.id.to_s).click
    fill_in 'source[title]', with: 'Edited source'
    fill_in 'source[notes]', with: 'Edited note'
    click_on 'Save Source'

    expect(page).to have_css('h1', text: 'Edited source')
    expect(page).to have_css('p', text: 'Edited note')
    visit sources_path
    expect(page).to have_css('table.sources td.title', text: 'Edited source')
  end

  scenario "deletes source" do
    pending "have to use selenium but it is running on dev, not test"
    # Capybara.current_driver = :selenium
    # Capybara.server = :puma
    sign_in_as('user@example.com')
    visit sources_path

    accept_alert do
      find('#delete-source-' + @source1.id.to_s).click
    end
  end

  scenario "filters source type" do
    sign_in_as('user@example.com')
    visit sources_path

    expect(page).to have_css('table.sources tbody tr', count: 2)

    select 'Artist', from: 'Source type'
    click_on 'Filter'
    expect(page).to have_css('table.sources tbody tr', count: 1)

    select 'Book', from: 'Source type'
    click_on 'Filter'
    expect(page).to have_css('table.sources tbody tr', count: 1)
  end

  scenario "sort by" do
    sign_in_as('user@example.com')
    visit sources_path

    select 'Title', from: 'sort'
    click_on 'Filter'
    expect(page).to have_xpath('//table/tbody/tr[1]/td[@class="title"]', text: 'A source')

    select 'Last Added', from: 'sort'
    click_on 'Filter'
    expect(page).to have_xpath('//table/tbody/tr[1]/td[@class="title"]', text: 'Second source')
  end
end
