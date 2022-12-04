class HomeController < ApplicationController

  def index
    @teams = [[1, "left"], [2, "right"]].map { |id, position| build_team(id, position) }
  end

  private

  def build_team(team_id, position)
    {
      id: team_id,
      units: Character.where(team: team_id),
      unit_types: CharacterValidator.team_constraints[team_id][:allowed_units],
      position: position
    }
  end

end