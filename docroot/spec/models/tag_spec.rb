require "rails_helper"

RSpec.describe Tag, :type => :model do

  before(:all) do
    @user1 = create(:user, email: 'user@example.com', password: '123456')
    @user2 = create(:user)
    @science_tag1 = create(:tag, user: @user1, title: "science")
    @science_tag2 = create(:tag, user: @user1, title: "philosophy")
  end

  it "is valid with valid attributes" do
    @tag1 = create(:tag, user: @user1)
    expect(@tag1).to be_valid

    @tag2 = create(:tag, user: @user2)
    expect(@tag2).to be_valid
  end

  it "gets tags by user" do
    @tags1 = Tag.by_user(@user1)
    expect(@tags1.count).to eq(2)

    @tags2 = Tag.by_user(@user2)
    expect(@tags2.count).to eq(0)
  end
end
