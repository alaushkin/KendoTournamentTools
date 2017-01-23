class Fight < ActiveRecord::Base
  belongs_to :white_person, class_name: 'Person', foreign_key: 'white_person_id', required: false
  belongs_to :red_person, class_name: 'Person', foreign_key: 'red_person_id', required: false
  belongs_to :winner, class_name: 'Person', foreign_key: 'winner_id', required: false
  has_many :childs, class_name: 'Fight', foreign_key: 'parent_id'
  belongs_to :fight_state
end