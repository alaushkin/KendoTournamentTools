class TournamentPool < ActiveRecord::Base
  belongs_to :tournament
  has_many :fights
end