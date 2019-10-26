# frozen_string_literal: true

require "rails_helper"

RSpec.describe Highlight, type: :model do
  before(:all) do
    @user1 = create(:user)
    @author1 = create(:author, user: @user1)
    @source1 = create(:source, user: @user1, authors: [@author1])
    @user2 = create(:user)
    @source2 = create(:source, user: @user2, authors: [@author1])
    @highlight1 = create(:highlight, user: @user1, source: @source1)
    @highlight2 = create(:highlight, user: @user1, source: @source1)
  end

  it "is valid with valid attributes" do
    expect(@highlight1).to be_valid
    expect(@highlight2).to be_valid
  end

  it "is not valid with other user's source" do
    @invalid_highlight = build(:highlight, user: @user1, source: @source2)
    expect(@invalid_highlight).to_not be_valid

    @invalid_highlight = build(:highlight, user: @user2, source: @source1)
    expect(@invalid_highlight).to_not be_valid
  end

  it "gets highlights by user" do
    @highlights = Highlight.by_user(@user1)
    expect(@highlights.count).to eq(2)

    @highlights = Highlight.by_user(@user2)
    expect(@highlights.count).to eq(0)
  end
end
