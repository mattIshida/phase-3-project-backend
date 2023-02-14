class Vote < ActiveRecord::Base
    belongs_to :bill, primary_key: :bill_id, foreign_key: :bill_id
    has_many :positions
    has_many :legislators, through: :positions
    has_many :comments, as: :commentable
    has_many :follows, as: :followable
    has_many :reactions, as: :reactable
end