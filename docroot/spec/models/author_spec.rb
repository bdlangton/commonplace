# frozen_string_literal: true

require "rails_helper"

RSpec.describe Author, type: :model do
  before(:all) do
    @user1 = create(:user)
    @user2 = create(:user)
    @author1 = create(:author, user: @user1)
    @author2 = create(:author, user: @user1)
  end

  it "is valid with valid attributes" do
    expect(@author1).to be_valid
    expect(@author2).to be_valid
  end

  it "is not valid with missing required fields" do
    @invalid_author = build(:author, user: @user1, name: "")
    expect(@invalid_author).to_not be_valid
  end

  it "gets authors by user" do
    @authors1 = Author.by_user(@user1)
    expect(@authors1.count).to eq(2)

    @authors2 = Source.by_user(@user2)
    expect(@authors2.count).to eq(0)
  end
end
