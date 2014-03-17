require 'spec_helper'
require 'cancan/matchers'
include CanCan::Ability

describe 'Ability' do
  context 'Users::Admin' do
    let(:user) { Users::Admin.create { FactoryGirl.attributes_for(:user, type: 'Users::Admin') } }
    let(:ability) { Ability.new(user) }

    it 'can manage everything' do
      expect(ability.can?(:manage, :all)).to eq(true)
    end
  end

  context 'Users::Contributor' do
    let(:user) { Users::Contributor.create { FactoryGirl.attributes_for(:user, type: 'Users::Contributor') } }
    let(:ability) { Ability.new(user) }
    let(:random_user) { FactoryGirl.create(:user) }

    it 'can create a document' do
      expect(ability.can?(:create, Document)).to eq(true)
    end

    context 'can consult a document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if he is a contributor of the document' do
        user.documents << document
        expect(ability.can?(:read, document)).to eq(true)
      end

      it 'if the document is archived' do
        document.state = 'archive'
        expect(ability.can?(:read, document)).to eq(true)
      end

      it 'if the document is validated' do
        document.state = 'validate'
        expect(ability.can?(:read, document)).to eq(true)
      end
    end

    context 'can not consult a document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if he is not a contributor of the document' do
        expect(ability.can?(:read, document)).to eq(false)
      end

      it 'if the document is not archived' do
        expect(ability.can?(:read, document)).to eq(false)
      end

      it 'if the document is not validated' do
        expect(ability.can?(:read, document)).to eq(false)
      end
    end

    context 'can change the state of the document' do
      let(:document) { FactoryGirl.create(:document) }

      before(:each) do
        user.documents << document
        document.state = 'wip'
      end

      it 'if he is a contributor of the document and if the document state is `wip`' do
        expect(ability.can?(:state, document)).to eq(true)
      end
    end

    context 'can not change the state of the document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if the document state is not `wip`' do
        user.documents << document
        document.state = 'archive'
        expect(ability.can?(:state, document)).to eq(false)
      end

      it 'if he is not a contributor of the document' do
        document.state = 'wip'
        expect(ability.can?(:state, document)).to eq(false)
      end
    end

    context 'can comment a document' do
      let(:document) { FactoryGirl.create(:document) }

      before(:each) do
        user.documents << document
        document.state = 'wip'
      end

      it 'if he is a contributor of the document and if the document state is `wip`' do
        expect(ability.can?(:comment, document)).to eq(true)
      end

      it 'if he is a contributor of the document and if the document state is `in_review`' do
        expect(ability.can?(:comment, document)).to eq(true)
      end
    end

    context 'can not comment a document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if the document state is not `wip` or `in_review`' do
        user.documents << document
        document.state = 'archive'
        expect(ability.can?(:comment, document)).to eq(false)
      end

      it 'if he is not a contributor of the document' do
        document.state = 'wip'
        expect(ability.can?(:comment, document)).to eq(false)
      end
    end

    context 'can edit a document' do
      let(:document) { FactoryGirl.create(:document) }

      before(:each) do
        user.documents << document
        document.state = 'wip'
      end

      it 'if he is a contributor of the document and if the document state is `wip`' do
        expect(ability.can?(:update, document)).to eq(true)
      end

      it 'if he is a contributor of the document and if the document state is `in_review`' do
        expect(ability.can?(:update, document)).to eq(true)
      end
    end

    context 'can not edit a document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if the document state is not `wip` or `in_review`' do
        user.documents << document
        document.state = 'archive'
        expect(ability.can?(:update, document)).to eq(false)
      end

      it 'if he is not a contributor of the document' do
        document.state = 'wip'
        expect(ability.can?(:update, document)).to eq(false)
      end
    end

    context 'can consult a user' do
      it 'if the user is himself' do
        expect(ability.can?(:read, user)).to eq(true)
      end
    end

    context 'can not consult a user' do
      it 'if the user is someone else' do
        expect(ability.can?(:read, random_user)).to eq(false)
      end
    end

    context 'can update a user' do
      it 'if the user is himself' do
        expect(ability.can?(:update, user)).to eq(true)
      end
    end

    context 'can not update a user' do
      it 'if the user is someone else' do
        expect(ability.can?(:update, random_user)).to eq(false)
      end
    end

    context 'can destroy a user' do
      it 'if the user is himself' do
        expect(ability.can?(:destroy, user)).to eq(true)
      end
    end

    context 'can not destroy a user' do
      it 'if the user is someone else' do
        expect(ability.can?(:destroy, random_user)).to eq(false)
      end
    end
  end

  context 'Users::Member' do
    let(:user) { Users::Member.create { FactoryGirl.attributes_for(:user, type: 'Users::Member') } }
    let(:ability) { Ability.new(user) }
    let(:random_user) { FactoryGirl.create(:user) }

    context 'can consult a document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if the document is archived' do
        document.state = 'archive'
        expect(ability.can?(:read, document)).to eq(true)
      end

      it 'if the document is validated' do
        document.state = 'validate'
        expect(ability.can?(:read, document)).to eq(true)
      end
    end

    context 'can not consult a document' do
      let(:document) { FactoryGirl.create(:document) }

      it 'if the document is not archived' do
        expect(ability.can?(:read, document)).to eq(false)
      end

      it 'if the document is not validated' do
        expect(ability.can?(:read, document)).to eq(false)
      end
    end

    context 'can consult a user' do
      it 'if the user is himself' do
        expect(ability.can?(:read, user)).to eq(true)
      end
    end

    context 'can not consult a user' do
      it 'if the user is someone else' do
        expect(ability.can?(:read, random_user)).to eq(false)
      end
    end

    context 'can update a user' do
      it 'if the user is himself' do
        expect(ability.can?(:update, user)).to eq(true)
      end
    end

    context 'can not update a user' do
      it 'if the user is someone else' do
        expect(ability.can?(:update, random_user)).to eq(false)
      end
    end

    context 'can destroy a user' do
      it 'if the user is himself' do
        expect(ability.can?(:destroy, user)).to eq(true)
      end
    end

    context 'can not destroy a user' do
      it 'if the user is someone else' do
        expect(ability.can?(:destroy, random_user)).to eq(false)
      end
    end
  end
end
