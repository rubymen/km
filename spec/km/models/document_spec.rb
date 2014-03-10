require 'spec_helper'

describe Document do
  subject(:document) { FactoryGirl.create(:document, title: 'Mon premier document', state: 'wip') }

  before :all do
    DatabaseCleaner.clean
  end

  context 'when extending from friendly_id' do
    it 'create slug' do
      expect(document.slug).to eq('mon-premier-document')
    end
  end

  context 'when state change' do
    describe 'initial state' do
      it 'should be at initial state' do
        expect(subject.state).to eq('wip')
      end
    end

    describe '#ask_for_review' do
      it 'should be in review state' do
        subject.ask_for_review
        expect(subject.state).to eq('in_review')
      end
    end

    describe '#rejected' do
      it 'should be in wip state' do
        subject.ask_for_review
        subject.rejected
        expect(subject.state).to eq('wip')
      end
    end

    describe '#validated' do
      it 'should be in validate state' do
        subject.ask_for_review
        subject.validated
        expect(subject.state).to eq('validate')
      end
    end

    describe '#archived' do
      it 'should be in archive state' do
        subject.ask_for_review
        subject.validated
        subject.archived
        expect(subject.state).to eq('archive')
      end
    end
  end

  it { expect have_and_belong_to_many(:users) }
  it { expect have_many(:attachments) }
  it { expect have_many(:comments) }
  it { expect have_and_belong_to_many(:tags) }

  it { expect validate_presence_of(:title) }
  it { expect validate_presence_of(:description) }

  it { expect accept_nested_attributes_for(:attachments) }

  describe '#search_data' do
    let(:hash_data) do
      {
        content:      subject.content,
        description:  subject.description,
        tags:         subject.tags.map(&:title),
        title:        subject.title,
        total_visits: subject.impressionist_count,
        updated_at:   subject.updated_at
      }
    end

    it 'returns indexed keys' do
      expect(hash_data).to eq(document.search_data)
    end
  end
end
