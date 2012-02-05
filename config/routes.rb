PlaceHoldIt::Application.routes.draw do
  match ':width/:height/:type' => 'image#generate'
end
