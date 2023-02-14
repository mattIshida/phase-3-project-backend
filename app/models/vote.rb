class Vote < ActiveRecord::Base
    belongs_to :bill, primary_key: :bill_id, foreign_key: :bill_id
    has_many :positions
    has_many :legislators, through: :positions
end