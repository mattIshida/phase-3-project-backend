class Tag < ActiveRecord::Base
    belongs_to :user
    belongs_to :bill
    belongs_to :subject
end