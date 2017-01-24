class Person < ActiveRecord::Base
  self.table_name = 'persons'
  has_many :tournament_persons
  belongs_to :level
  belongs_to :club
  def fio
    "#{last_name} #{first_name} #{middle_name}"
  end
end