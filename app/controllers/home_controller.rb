class HomeController < ApplicationController

def index
  @team1 = Character.where(team: 1)
  @team2 = Character.where(team: 2)
end
  
end