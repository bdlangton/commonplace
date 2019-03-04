require 'rails_helper'
require 'features/general'
require 'features/sign_in'

include Features

feature "highlights" do
  background do
    @user1 = create(:user, email: 'user@example.com', password: '123456')
    @source1 = create(:source, user: @user1)
    @user2 = create(:user, email: 'user2@example.com', password: '123456')
    @source2 = create(:source, user: @user2)
  end

  scenario "adds new highlight" do
    sign_in_as('user@example.com')
    visit highlights_path
    pending "pending"
    expect(1).to eq(2)
  end

  scenario "favorites highlight" do
    sign_in_as('user@example.com')
    visit highlights_path
    pending "pending"
    expect(1).to eq(2)
  end

  scenario "unfavorites highlight" do
    sign_in_as('user@example.com')
    visit highlights_path
    pending "pending"
    expect(1).to eq(2)
  end

  scenario "edits highlight" do
    sign_in_as('user@example.com')
    visit highlights_path
    pending "pending"
    expect(1).to eq(2)
  end

  scenario "filters highlights" do
    sign_in_as('user@example.com')
    visit highlights_path
    pending "pending"
    expect(1).to eq(2)
  end

  scenario "deletes highlight" do
    sign_in_as('user@example.com')
    visit highlights_path
    pending "pending"
    expect(1).to eq(2)
  end
end
