module Features
  # Confirm that the main menu shows.
  def has_main_menu
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Highlights'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Favorites'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Tags'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Sources'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Import'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Logout'
  end

  # Get the table row for the specific highlight.
  def get_highlight_row(highlight)
    '//table/tbody/tr[@class="highlight-' + highlight.id.to_s + '"]'
  end

  # Create a new highlight through the UI.
  def create_highlight(tags = '')
    visit highlights_path
    click_on 'New highlight'
    fill_in 'highlight[highlight]', with: 'My highlight'
    fill_in 'highlight[note]', with: 'My note'
    fill_in 'highlight[all_tags]', with: tags
    click_on 'Save Highlight'
  end

  # Select an element from a chosen select.
  def select_from_chosen(item_text, options)
    field = find_field(options[:from], :visible => false)
    find("##{field[:id]}_chosen").click
    find("##{field[:id]}_chosen ul.chosen-results li", :text => item_text).click
  end
end
