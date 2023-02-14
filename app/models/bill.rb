class Bill < ActiveRecord::Base
    has_many :votes, primary_key: :bill_id, foreign_key: :bill_id
    has_many :positions, primary_key: :bill_id, foreign_key: :bill_id
    has_many :legislators, through: :positions
end