class Bill < ActiveRecord::Base
    has_many :votes, primary_key: :bill_id, foreign_key: :bill_id
    has_many :positions, primary_key: :bill_id, foreign_key: :bill_id
    has_many :legislators, through: :positions
    has_many :comments, as: :commentable
    has_many :follows, as: :followable
    has_many :reactions, as: :reactable
    has_many :tags
    has_many :subjects, through: :tags
end