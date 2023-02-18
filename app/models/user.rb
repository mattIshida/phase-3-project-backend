class User < ActiveRecord::Base
    has_many :reactions
    has_many :follows
    has_many :comments
    
    def legislators_followed
        legislators = self.follows.where(followable_type: "Legislator")
        legislators.map {|leg| leg.followable}
    end
end