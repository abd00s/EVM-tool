class Schedule < ActiveRecord::Base
  belongs_to :project
  has_many :periods
end
