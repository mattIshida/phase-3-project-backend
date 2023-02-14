class Legislator < ActiveRecord::Base
    has_many :positions, primary_key: :member_id, foreign_key: :member_id
    has_many :bills, through: :positions
    has_many :votes, through: :positions
end