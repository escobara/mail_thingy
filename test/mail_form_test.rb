require 'test_helper'
require "fixtures/sample_mail"

class MailFormTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "sample mail has a name" do
    sample = SampleMail.new
    sample.name = 'User'
    assert_equal 'User', sample.name
  	sample.email = 'rene@example.com'
  	assert_equal 'rene@example.com', sample.email
  end

  test 'sample mail can clear attributes using the clear _prefix' do 
  	sample = SampleMail.new
  	sample.name = 'User'
  	sample.email = 'user@example.com'
    assert_equal 'User', sample.name
  	assert_equal 'user@example.com', sample.email
  	sample.clear_name
  	sample.clear_email
  	assert_nil sample.name
  	assert_nil sample.email
  end

  test 'sample mail can ask if the method is present or not' do 
  	sample = SampleMail.new
  	assert !sample.name?

  	sample.name = 'User'
  	assert sample.name?

  	sample.email = ''
  	assert !sample.email?
  end

  test 'delivers an email with attributes' do 
    sample = SampleMail.new

    sample.email = 'user@example.com'
    sample.deliver 

    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last

    assert_equal ['user@example.com'], mail.from
    assert_match "Email: user@example.com", mail.body.encoded
  end

  test 'validates absence of nickname' do
    sample = SampleMail.new(nickname: 'Spam')
    assert !sample.valid?
    assert_equal ["is invalid"], sample.errors[:nickname]
  end

  
end
