PlaceHoldIt::Application.routes.draw do
  match ':type/(:width)x(:height)' => 'image#generate'
end
