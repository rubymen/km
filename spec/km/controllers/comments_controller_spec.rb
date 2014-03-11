require 'spec_helper'
require 'controller_helper'
require 'factory_girl'

describe CommentsController, type: :controller do
  subject(:comment) { FactoryGirl.create(:comment) }

  let(:document) { FactoryGirl.create(:document) }

  before(:each) do
    sign_in FactoryGirl.create(:user, firstname: 'admin', lastname: 'nimda', type: 'Users::Admin')
    document.comments << subject
  end

  describe 'GET #index' do
    before(:each) do
      get :index, document_id: document.id
    end

    it 'assign @tags' do
      expect(assigns(:comments)).to eq(document.comments)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before(:each) do
        post :create, { document_id: document.id, comment: { title: 'I am Chuck Norris' } }
      end

      it 'creates a new comment' do
        expect(assigns(:comment)).to be_a(Comment)
      end

      it 'redirects to the new comment' do
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new comment' do
        expect { post :create, document_id: document.id, comment: { title: '' }}.to_not change(Comment,:count)
      end

      it 're-renders the new method' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:comment_deleted) { FactoryGirl.build(:comment) }

    before (:each) do
      comment_deleted.save
    end

    it 'does delete the comment'  do
      expect { delete :destroy, { id: comment_deleted, document_id: document.id } }.to change(Comment,:count)
    end

    it 'redirects to ' do
      delete :destroy, { id: comment_deleted, document_id: document.id }
      expect(response).to redirect_to(document_comments_path(document))
    end
  end
end
