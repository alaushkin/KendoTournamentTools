Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#hello'
  scope '/tournament' do
    get '/page' => 'tournament#page'
    post '/save' => 'tournament#save'
    get '/:id' => 'tournament#details'
  end
  scope '/status' do
    get '/all' => 'status#findAll'
  end
  scope '/level' do
    get '/all' => 'level#findAll'
  end
  scope '/tournament-type' do
    get '/all' => 'tournament_type#findAll'
  end
end
