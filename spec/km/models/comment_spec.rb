require 'spec_helper'

describe Comment do
  before :all do
    DatabaseCleaner.clean
  end

  it { should belong_to(:comment) }
  it { should belong_to(:document) }
  it { should belong_to(:user) }

  it { should have_many(:comments) }

  it { should validate_presence_of(:content) }
end
