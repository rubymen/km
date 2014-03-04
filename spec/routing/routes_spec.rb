require 'spec_helper'

describe 'Routing' do
  it { expect(delete: '/users/1').to route_to('users#destroy', id: '1') }
  it { expect(delete: '/users/sign_out').to route_to('devise/sessions#destroy') }
  it { expect(get: '/users').to route_to('users#index') }
  it { expect(get: '/users/1').to route_to('users#show', id: '1') }
  it { expect(get: '/users/1/edit').to route_to('users#edit', id: '1') }
  it { expect(get: '/users/password/edit').to route_to('devise/passwords#edit') }
  it { expect(get: '/users/password/new').to route_to('devise/passwords#new') }
  it { expect(get: '/users/sign_in').to route_to('devise/sessions#new') }
  it { expect(post: '/users/password').to route_to('devise/passwords#create') }
  it { expect(post: '/users/sign_in').to route_to('devise/sessions#create') }
  it { expect(put: '/users/1').to route_to('users#update', id: '1') }
  it { expect(put: '/users/password').to route_to('devise/passwords#update') }

  it { expect(get: '/').to route_to('documents#index') }

  it { expect(delete: '/documents/1').to route_to('documents#destroy', id: '1') }
  it { expect(delete: '/documents/1/comments/1').to route_to('comments#destroy', document_id: '1', id: '1') }
  it { expect(get: '/documents').to route_to('documents#index') }
  it { expect(get: '/documents/1').to route_to('documents#show', id: '1') }
  it { expect(get: '/documents/1/change_version').to route_to('documents#change_version', id: '1') }
  it { expect(get: '/documents/1/comments').to route_to('comments#index', document_id: '1') }
  it { expect(get: '/documents/1/comments/1/comments/new').to route_to('comments#new', document_id: '1', comment_id: '1') }
  it { expect(get: '/documents/1/comments/new').to route_to('comments#new', document_id: '1') }
  it { expect(get: '/documents/1/edit').to route_to('documents#edit', id: '1') }
  it { expect(get: '/documents/1/state').to route_to('documents#state', id: '1') }
  it { expect(get: '/documents/1/zip').to route_to('documents#zip', id: '1') }
  it { expect(get: '/documents/autocomplete').to route_to('documents#autocomplete') }
  it { expect(get: '/documents/new').to route_to('documents#new') }
  it { expect(post: '/documents').to route_to('documents#create') }
  it { expect(post: '/documents/1/comments').to route_to('comments#create', document_id: '1') }
  it { expect(post: '/documents/1/comments/1/comments').to route_to('comments#create', document_id: '1', comment_id: '1') }
  it { expect(put: '/documents/1').to route_to('documents#update', id: '1') }

  it { expect(delete: '/tags/1').to route_to('tags#destroy', id: '1') }
  it { expect(get: '/tags').to route_to('tags#index') }
  it { expect(get: '/tags/1').to route_to('tags#show', id: '1') }
  it { expect(get: '/tags/1/edit').to route_to('tags#edit', id: '1') }
  it { expect(get: '/tags/new').to route_to('tags#new') }
  it { expect(post: '/tags').to route_to('tags#create') }
  it { expect(put: '/tags/1').to route_to('tags#update', id: '1') }

  it { expect(get: '/dashboard').to route_to('high_voltage/pages#show', id: 'dashboard') }
  it { expect(get: '/pages/1').to route_to('high_voltage/pages#show', id: '1') }
end
