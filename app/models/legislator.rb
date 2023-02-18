class Legislator < ActiveRecord::Base
    has_many :positions, primary_key: :member_id, foreign_key: :member_id
    has_many :bills, through: :positions
    has_many :votes, through: :positions
    has_many :comments, as: :commentable
    has_many :follows, as: :followable
    has_many :reactions, as: :reactable

    def summary_stats
        {follower_count: self.follows.length,
         sentiment: self.reactions.map {|r| r.value}.sum
    }
    end

    def recent_votes
        bills = Vote.all.limit(5).map {|v| v.bill}
        bills.map {|b| self.positions.find_by(bill_id: b.bill_id)}
    end

end