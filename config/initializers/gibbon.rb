###################################
##  Wrapper for MailChimp's API  ##
###################################

Gibbon::Request.api_key = ENV['MAILCHIMP_API_KEY']
Gibbon::Request.timeout = 15
Gibbon::Request.debug = true
# Gibbon::Request.throws_exceptions = false