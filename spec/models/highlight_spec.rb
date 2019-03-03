require "rails_helper"

RSpec.describe Highlight, :type => :model do

  before(:all) do
    @user1 = create(:user)
    @source1 = create(:source, user: @user1)
    @user2 = create(:user)
    @source2 = create(:source, user: @user2)
  end

  it "is valid with valid attributes" do
    @highlight1 = create(:highlight, user: @user1, source: @source1)
    expect(@highlight1).to be_valid
    @highlight2 = create(:highlight, user: @user2, source: @source2)
    expect(@highlight2).to be_valid
  end

  it "is not valid with other user's source" do
    pending "make this work"
    @highlight1 = create(:highlight, user: @user1, source: @source2)
    expect(@highlight1).to_not be_valid
    @highlight2 = create(:highlight, user: @user2, source: @source1)
    expect(@highlight2).to_not be_valid
  end

end
