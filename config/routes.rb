Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :submissions, only: [:index, :show]

  resources :tests do 
    member do 
      get :preview_test
    end
    collection do 
      post :collect_user_response
    end
  end

  get '/previous' => 'tests#previous_question'
  get '/next' => 'tests#next_question'
  get '/question' => 'tests#question_list'
end
