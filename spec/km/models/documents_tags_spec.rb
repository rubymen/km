require 'spec_helper'

describe DocumentsTags do
  it { should belong_to(:document) }
  it { should belong_to(:tag) }
end
