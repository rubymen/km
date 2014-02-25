require 'spec_helper'

describe User do
  subject(:user) { FactoryGirl.create(:user, firstname: 'admin', lastname: 'nimda', phone: '+33606060606') }

  before :all do
    DatabaseCleaner.clean
  end

  it { should have_and_belong_to_many(:documents) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:type) }

  it 'validates presence of birthdate' do
    User.validates_date :birthdate
  end

  it { should validate_uniqueness_of(:email) }
  it { expect(user.phone).to match /((\+|00)33\s?|0)[3679](\s?\d{2}){4}/ }
  it { should allow_value('').for(:phone) }

  context 'when extending from friendly_id' do
    it 'create slug' do
      expect(user.slug).to eq('admin-nimda')
    end
  end

  describe '#name' do
    it "returns the user's firstname and lastname" do
      expect(user.name).to eq("#{user.firstname} #{user.lastname}")
    end
  end
end
