class TournamentPerson < ActiveRecord::Base
  self.table_name = 'tournament_persons'
  validates :tournament_id, uniqueness:{ scope: :person_id, message: 'Участник уже зарегистрирован на турнир' }
  belongs_to :tournament
  belongs_to :person
end