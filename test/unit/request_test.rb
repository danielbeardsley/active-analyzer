require File.dirname(__FILE__) + '/../test_helper'

class RequestTest < ActiveSupport::TestCase
  should_have_many :event_logs
  should_belong_to :application
end
