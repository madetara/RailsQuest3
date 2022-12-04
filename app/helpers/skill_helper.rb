# frozen_string_literal: true

module SkillHelper
  def can_use_ultimate?(team_id)
    Character.can_use_ultimate?(team_id)
  end
end
