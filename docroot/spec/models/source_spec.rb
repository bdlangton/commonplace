# frozen_string_literal: true

require "rails_helper"

RSpec.describe Source, type: :model do
  before(:all) do
    @user1 = create(:user)
    @user2 = create(:user)
    @author1 = create(:author, user: @user1)
    @source1 = create(:source, user: @user1, authors: [@author1])
    @source2 = create(:source, user: @user1, authors: [@author1])
  end

  it "is valid with valid attributes" do
    expect(@source1).to be_valid
    expect(@source2).to be_valid
  end

  it "gets sources by user" do
    @sources1 = Source.by_user(@user1)
    expect(@sources1.count).to eq(2)

    @sources2 = Source.by_user(@user2)
    expect(@sources2.count).to eq(0)
  end
end
