Rails.application.routes.draw do
  root "home#index"

  put '/teams/:team_id/units/:unit_type', to: 'teams#add_unit'

  post '/teams/:team_id/skills/ultimate', to: 'teams#use_ultimate'
end
