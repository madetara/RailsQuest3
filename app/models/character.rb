class CharacterValidator < ActiveModel::Validator
  def self.team_constraints
    {
      1 => { allowed_units: %w(knight mage) },
      2 => { allowed_units: %w(medusa jinn) }
    }
  end

  def validate(record)
    allowed_units = CharacterValidator.team_constraints[record.team][:allowed_units]

    unless allowed_units.include?(record.unit)
      record.errors.add :base, "Team #{record.team} only accepts #{allowed_units}. Got: #{record.unit}"
    end
  end
end

class Character < ApplicationRecord
  validates :unit, presence: true, inclusion: { in: CharacterValidator.team_constraints.values
                                                                      .map { |v| v[:allowed_units] }
                                                                      .flatten }
  validates :team, presence: true, inclusion: { in: CharacterValidator.team_constraints.keys }

  validates_with CharacterValidator, if: :valid_team?

  def valid_team?
    !team.blank? && CharacterValidator.team_constraints.keys.include?(team)
  end
end
