class Tournament < ActiveRecord::Base
  belongs_to :status
  belongs_to :tournament_type
end