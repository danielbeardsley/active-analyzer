require File.dirname(__FILE__) + '/../test_helper'

class ApplicationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_batches_relation
    app = Application.find(2)
    batches = app.batches
    assert_equal 4, batches.length
    assert_equal 2, batches[0].application_id
  end
  
  def test_validations
    app = Application.new({:name => nil})
    assert !app.valid?, 'Application.name is allowed to be blank'
  end
end
