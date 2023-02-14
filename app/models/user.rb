class User < ActiveRecord::Base
    has_many :reactions
    has_many :follows
    has_many :comments
end