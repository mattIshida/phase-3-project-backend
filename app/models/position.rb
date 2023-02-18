class Position < ActiveRecord::Base
    belongs_to :legislator, foreign_key: :member_id, primary_key: :member_id
    belongs_to :vote
    belongs_to :bill, foreign_key: :bill_id, primary_key: :bill_id
    has_many :comments, as: :commentable
    has_many :follows, as: :followable
    has_many :reactions, as: :reactable
end