module Features
  def has_main_menu
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Highlights'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Favorites'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Tags'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Sources'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Import'
    expect(page).to have_css 'ul.navbar-nav li a', text: 'Logout'
  end
end
