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

  def self.ultimates
    {
      1 => {
        condition: -> do
          Character.where(team: 1).group(:unit).having("COUNT(id) >= ?", 2).length >= 2
        end,
        action: -> do
          new_knights = Array.new(5, { team: 1, unit: "knight" })
          Character.create(new_knights)
        end },
      2 => {
        condition: -> do
          team_stats = Character.where(team: 2).group(:unit).count
          return team_stats.fetch("medusa", 0) >= 1 && team_stats.fetch("jinn", 0) >= 2
        end,
        action: -> do
          enemy_ids = Character.where(team: 1).pluck(:id).shuffle
          Character.destroy(enemy_ids[..2])
        end }
    }
  end

  def self.can_use_ultimate?(team_id)
    ultimates[team_id][:condition].call
  end

  def self.use_ultimate(team_id)
    ultimates[team_id][:action].call if can_use_ultimate?(team_id)
  end
end
