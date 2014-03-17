require 'spec_helper'
require 'factory_girl'

describe DocumentsController, type: :controller, versioning: true do
  subject(:document) { FactoryGirl.create(:document) }

  before(:each) do
    Document.stub(:reindex)
    Document.stub(:to_search) { Document.all }
    sign_in FactoryGirl.create(:user, firstname: 'admin', lastname: 'nimda', type: 'Users::Admin')
  end

  describe 'POST #change_version' do
    let(:attr) { FactoryGirl.attributes_for(:document_with_user) }

    let(:subject_before_changes) { subject }

    before(:each) do
      put :update, id: subject.id, document: attr
      subject.reload

      tags  = subject.tags.each { |t| t }
      users = subject.users.each { |u| u }

      version_to_change = subject.versions[0]

      subject.destroy
      subject = PaperTrail::Version.find(version_to_change).reify
      subject.tags  << tags
      subject.users << users
      subject.save
    end

    it 'change the version of the document' do
      expect(subject).to eq(subject_before_changes)
    end
  end

  describe 'GET #index' do
    before(:each) do
      get :index
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before(:each) do
      get :show, id: subject
    end

    it 'assigns the requested document to @document' do
      expect(assigns(:document)).to eq(subject)
    end

    it 'render the #show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new document' do
        expect { post :create, document: FactoryGirl.attributes_for(:document_with_user) }.to change(Document, :count)
      end

      it 'redirects to the new document' do
        post :create, document: FactoryGirl.attributes_for(:document_with_user)
        expect(response).to redirect_to(document_path(assigns(:document)))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new document' do
        expect { post :create, document: { title: '' } }.to_not change(Document, :count)
      end

      it 're-renders the new method' do
        post :create, document: { title: '' }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    before(:each) do
      get :edit, id: subject
    end

    it 'assigns the requested document to @document' do
      expect(assigns(:document)).to eq(subject)
    end

    it 'render the #edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let(:attr) { FactoryGirl.attributes_for(:document) }

      before(:each) do
        put :update, id: subject.id, document: attr
        subject.reload
      end

      it 'update the title' do
        expect(subject.title).to eq(attr[:title])
      end

      it 'create a new version of the document' do
        expect(subject.versions.size).to eq(1)
      end

      it 'redirects to the updated document' do
        put :update, id: subject.id, document: FactoryGirl.attributes_for(:document_with_user)
        expect(response).to redirect_to(document_path(assigns(:document)))
      end
    end

    context 'with invalid attributes' do
      let(:attr) { FactoryGirl.attributes_for(:document, { title: '', description: 'new description', content: 'new content' }) }

      before(:each) do
        put :update, id: subject.id, document: attr
        subject.reload
      end

      context 'does not update' do
        it 'the title' do
          expect(subject.title).to_not eq(attr[:title])
        end

        it 'the description' do
          expect(subject.description).to_not eq(attr[:description])
        end

        it 'the content' do
          expect(subject.content).to_not eq(attr[:content])
        end
      end

      it 'does not create a new version of the document' do
        expect(subject.versions.size).to eq(0)
      end

      it 're-renders the update method' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:document_deleted) { FactoryGirl.build(:document) }

    before(:each) do
      document_deleted.save
    end

    it 'deletes the document' do
      expect { delete :destroy, id: document_deleted }.to change(Document, :count)
    end

    it "redirects to the new document's form" do
      delete :destroy, id: document_deleted
      expect(response).to redirect_to(new_document_path)
    end
  end
end
