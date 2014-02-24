require 'spec_helper'

describe Users::Member do
  subject(:user) { FactoryGirl.create(:user, firstname: 'admin', lastname: 'nimda', type: 'Users::Member') }

  before :all do
    DatabaseCleaner.clean
  end

  it { expect(Users::Admin).to be < User }

  describe '.model_name' do
    it "returns the user's model name" do
      expect(user).to be_kind_of(User)
    end
  end
end
