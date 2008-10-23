# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class BaseController < ActionController::Base
  helper :all # include all helpers, all the time
  layout 'main'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'bf898d0b2f8be13524e221ed0784dc34'
end
