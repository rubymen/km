require 'spec_helper'
require 'factory_girl'

describe ApplicationHelper, type: :helper do
  describe '#to_b' do
    context 'returns a boolean equal to' do
      it 'true if the sent integer is superior to zero' do
        expect(to_b(rand(1..30))).to eq(true)
      end

      it 'false if the sent integer is equal to zero' do
        expect(to_b(0)).to eq(false)
      end
    end
  end

  describe '#keywords' do
    it 'should returns the good keywords' do
      expect(keywords).to eq('documents, milicon, knowledge, management, manager, km, knowledge management, knowledge-management, knowledgemanagement, rubymen, ruby on rails, document, tag')
    end
  end
end
