require 'spec_helper'
require 'controller_helper'
require 'factory_girl'

describe UsersController, type: :controller do
  subject(:user) { FactoryGirl.create(:user, firstname: 'admin', lastname: 'nimda', type: 'Users::Admin') }

  before(:each) do
    sign_in user
    User.reindex
  end

  describe 'GET #index' do
    before(:each) do
      get :index
    end

    it 'assign @users' do
      expect(assigns(:users)).to be_a(Searchkick::Results)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      get :show, id: subject
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user).id).to eq(subject.id)
    end

    it 'render the #show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect { post :create, user: FactoryGirl.attributes_for(:user, type: 'Users::Admin') }.to change(User,:count)
      end

      it 'redirects to the new user' do
        post :create, user: FactoryGirl.attributes_for(:user, type: 'Users::Admin')
        expect(response).to redirect_to(user_path(assigns(:user)))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new user' do
        expect { post :create, user: { name: '' }}.to_not change(User,:count)
      end

      it 're-renders the new method' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user_deleted) { FactoryGirl.build(:user, type: 'Users::Admin') }

    before (:each) do
      user_deleted.save
    end

    it 'does delete the user'  do
      expect { delete :destroy, id: user_deleted }.to change(User,:count)
    end

    it 'redirects to ' do
      delete :destroy, id: user_deleted
      expect(response).to redirect_to(new_user_path)
    end
  end
end
