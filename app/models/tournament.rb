class Tournament < ActiveRecord::Base
  belongs_to :status
  belongs_to :tournament_type
  has_many :tournament_person
  has_many :tournament_pools
end