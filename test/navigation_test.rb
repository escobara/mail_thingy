require "test_helper"

class NavigationTest < ActiveSupport::IntegrationCase
	setup do 
		ActionMailer::Base.deliveries.clear
	end

	test 'sends an email after filling out the contact form' do 
		visit '/'

		fill_in 'Name', with: 'John Doe'
		fill_in 'Email', with: 'john@example.com'
		fill_in 'Message', with: 'testing this message'

		click_button 'Deliver'

		assert_match 'Your message was successfully sent', page.body

		assert_equal 1, ActionMailer::Base.deliveries.size
		mail = ActionMailer::Base.deliveries.last

		assert_equal ['john@example.com'], mail.from
		assert_equal ['recipient@example.com'], mail.to
		assert_match 'Message: testing this message', mail.body.encoded
	end
end
