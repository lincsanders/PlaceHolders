PlaceHoldIt::Application.routes.draw do
  root :to => 'application#index'

  match ':type/(:width)x(:height)' => 'image#generate'
end
