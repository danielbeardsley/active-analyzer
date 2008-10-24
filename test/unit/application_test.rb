require File.dirname(__FILE__) + '/../test_helper'

class ApplicationTest < ActiveSupport::TestCase
  should_have_many :batches
  should_have_many :templates
  should_have_many :requests
  
  should_require_attributes :name
end
