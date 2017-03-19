class SubscribeUserToMailingListJob < ApplicationJob
  queue_as :default

  def perform(user)
    logger.info "signing up #{user.email}"
    subscribe(user)
  end

  def subscribe(user)
    mailchimp = Gibbon::Request.new
    list_id = ENV['MAILCHIMP_LIST_ID']
    
    result = mailchimp.lists(list_id).members.create(
      body: {
        email_address: user.email,
        status: 'subscribed',
        merge_fields: {
          FNAME: user.first_name,
          LNAME: user.last_name
        }
    })

    Rails.logger.info("Subscribed #{user.email} to MailChimp") if result
  end
  
end