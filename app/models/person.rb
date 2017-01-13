class Person < ActiveRecord::Base
  self.table_name = 'persons'
  has_many :tournament_persons
  belongs_to :level
  belongs_to :club
end