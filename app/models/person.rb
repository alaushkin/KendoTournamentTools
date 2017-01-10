class Person < ActiveRecord::Base
  self.table_name = "persons"
  belongs_to :level
  belongs_to :club
end