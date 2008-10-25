class Application < ActiveRecord::Base
  has_many :batches
  has_many :requests
  has_many :templates
  validates_presence_of :name
end
