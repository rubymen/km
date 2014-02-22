require 'spec_helper'

describe Tag do
  subject(:tag) { FactoryGirl.create(:tag, title: 'Ruby On Rails') }

  before :all do
    DatabaseCleaner.clean
  end

  it { should have_and_belong_to_many(:documents) }

  it { should validate_presence_of(:title) }

  context 'when extending from friendly_id' do
    it 'create slug' do
      expect(tag.slug).to eq('ruby-on-rails')
    end
  end

  describe '.to_s' do
    it 'returns the title' do
      expect(tag.to_s).to eq(tag.title)
    end
  end
end
