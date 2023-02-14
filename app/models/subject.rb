class Subject < ActiveRecord::Base
    has_many :tags
    has_many :bills, through: :tags
    has_many :follows, as: :followable
end