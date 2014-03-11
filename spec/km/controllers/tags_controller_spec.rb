require 'spec_helper'
require 'controller_helper'
require 'factory_girl'

describe TagsController, type: :controller do
  subject(:tag) { FactoryGirl.create(:tag, title: 'Ruby On Rails') }

  let(:user) { FactoryGirl.create(:user, firstname: 'admin', lastname: 'nimda', type: 'Users::Admin') }

  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    before(:each) do
      get :index
    end

    it 'assign @tags' do
      expect(assigns(:tags)).to eq(Tag.all)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      get :show, id: subject
    end

    it 'assigns the requested tag to @tag' do
      expect(assigns(:tag)).to eq(subject)
    end

    it 'render the #show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before(:each) do
        post :create, tag: { title: 'Javascript' }
      end

      it 'creates a new tag' do
        expect(assigns(:tag)).to be_a(Tag)
      end

      it 'redirects to the new tag' do
        expect(response).to redirect_to(tag_path(assigns(:tag)))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new tag' do
        expect { post :create, tag: { content: '' }}.to_not change(Tag,:count)
      end

      it 're-renders the new method' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:tag_deleted) { FactoryGirl.build(:tag, title: 'Ready to be deleted') }

    before (:each) do
      tag_deleted.save
    end

    it 'does delete the tag'  do
      expect { delete :destroy, id: tag_deleted }.to change(Tag,:count)
    end

    it 'redirects to ' do
      delete :destroy, id: tag_deleted
      expect(response).to redirect_to(new_tag_path)
    end
  end
end
