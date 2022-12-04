class TeamsController < ApplicationController
  def add_unit
    c = Character.create(unit: team_params[:unit_type], team: team_params[:team_id])

    unless c.valid?
      flash.now[:error] = c.errors.full_messages
    end

    redirect_to '/'
  end

  def use_ultimate
    Character.use_ultimate(team_params[:team_id].to_i)

    redirect_to '/'
  end

  private

  def team_params
    params.require(:team_id)
    params.permit(:team_id, :unit_type, :unit_count)
  end

end