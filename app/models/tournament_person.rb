class TournamentPerson < ActiveRecord::Base
  has_many :tournament, :person
end