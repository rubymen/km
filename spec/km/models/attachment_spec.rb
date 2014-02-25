require 'spec_helper'

describe Attachment do
  before :all do
    DatabaseCleaner.clean
  end

  it { should belong_to(:document) }
end
