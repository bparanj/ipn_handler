# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
IpnHandler::Application.initialize!

paypal_logger = ActiveSupport::BufferedLogger.new(Rails.root.join('log/status.log'))
