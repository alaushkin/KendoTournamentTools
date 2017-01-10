class TournamentPerson < ActiveRecord::Base
  self.table_name = "tournament_persons"
  belongs_to :tournament
  belongs_to :person
end