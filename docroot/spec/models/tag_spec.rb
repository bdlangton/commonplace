# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tag, type: :model do
  before(:all) do
    @user1 = create(:user, email: "user@example.com", password: "123456")
    @user2 = create(:user)
    @tag1 = create(:tag, user: @user1, title: "science")
    @tag2 = create(:tag, user: @user1, title: "philosophy")
    @tag3 = create(:tag, user: @user2, title: "science")
    @tag4 = create(:tag, user: @user1, title: "religion")
    @author1 = create(:author, user: @user1)
    @source1 = create(:source, user: @user1, authors: [@author1])
    @author2 = create(:author, user: @user2)
    @source2 = create(:source, user: @user2, authors: [@author2])
    @highlight1 = create(:highlight, user: @user1, source: @source1, tags: [@tag1, @tag2])
    @highlight2 = create(:highlight, user: @user2, source: @source2, tags: [@tag3])
    @highlight3 = create(:highlight, user: @user1, source: @source1, tags: [@tag4])
  end

  it "is valid with valid attributes" do
    @tag = create(:tag, title: "tag 1", user: @user1)
    expect(@tag).to be_valid

    @tag = create(:tag, title: "tag 2", user: @user2)
    expect(@tag).to be_valid
  end

  it "is not valid with missing required fields" do
    @invalid_tag = build(:tag, user: @user1, title: "")
    expect(@invalid_tag).to_not be_valid
  end

  it "gets tags by user" do
    @tags1 = Tag.by_user(@user1)
    expect(@tags1.count).to eq(3)

    @tags2 = Tag.by_user(@user2)
    expect(@tags2.count).to eq(1)
  end

  it "gets tags by source" do
    @tags = Tag.by_source(@source1.id)
    expect(@tags.count).to eq(3)

    @tags = Tag.by_source(@source2.id)
    expect(@tags.count).to eq(1)
  end

  it "gets tags by author" do
    @tags = Tag.by_author(@author1.id)
    expect(@tags.count).to eq(3)

    @tags = Tag.by_author(@author2.id)
    expect(@tags.count).to eq(1)
  end
end
