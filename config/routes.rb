Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'user/sessions' }
  devise_scope :user do
    get 'sign_in', to: 'user/sessions#new'
    post 'sign_in', to: 'user/sessions#create'
    get 'register', to: 'user/registrations#new'
    post 'register', to: 'user/registrations#create'
    delete 'sign_out', to: 'user/sessions#destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#hello'
  scope '/views' do
    scope '/tournament' do
      get '/page' => 'tournament#page_view'
      get '/new' => 'tournament#new_view'
      get '/edit/:id' => 'tournament#edit_view'
      get '/:id' => 'tournament#details_view'
    end
    scope '/person' do
      get '/page' => 'person#page_view'
      get 'new' => 'person#new_view'
      get '/edit/:id' => 'person#edit_view'
      get '/:id' => 'person#details_view'
    end
    scope '/tournament-person' do
      get '/add_persons' => 'tournament_person#add_persons_view'
    end
  end
  scope '/rest' do
    scope '/tournament' do
      get '/page' => 'tournament#page'
      post '/save' => 'tournament#save'
      post '/update' => 'tournament#update'
      get '/:id' => 'tournament#details'
    end
    scope 'person' do
      get '/all' => 'person#findAll'
      get '/check' => 'person#check'
      get '/:id' => 'person#details'
      post '/save' => 'person#save'
      post '/update' => 'person#update'
    end
    scope '/status' do
      get '/all' => 'status#findAll'
    end
    scope '/level' do
      get '/all' => 'level#findAll'
    end
    scope '/club' do
      get '/all' => 'club#findAll'
    end
    scope '/tournament-type' do
      get '/all' => 'tournament_type#findAll'
    end
    scope '/tournament-person' do
      get '/:tournament_id' => 'tournament_person#persons_by_tournament'
      post '/add_persons' => 'tournament_person#add_persons'
      get '/remove_person' => 'tournament_person#remove_person'
      post '/:tournament_id/import-persons' => 'tournament_person#import_persons'
    end
  end
end
