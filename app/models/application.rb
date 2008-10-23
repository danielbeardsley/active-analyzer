class Application < ActiveRecord::Base
  has_many :batches
  validates_presence_of :name
end
