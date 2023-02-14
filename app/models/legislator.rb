class Legislator < ActiveRecord::Base
    has_many :positions, primary_key: :member_id, foreign_key: :member_id
    has_many :bills, through: :positions
    has_many :votes, through: :positions
    has_many :comments, as: :commentable
    has_many :follows, as: :followable
    has_many :reactions, as: :reactable
end