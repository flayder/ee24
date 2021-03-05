shared_examples_for 'approval notifiable' do
  let(:mail) { UserMailer.send(:approval_notification, obj.class.name, obj.id) }

  it 'renders the subject' do
    mail.subject.should eq(I18n.translate("approval_email_subjects.new_#{obj.class.name.underscore}", :title => obj.title))
  end

  it 'renders the receiver email' do
    mail.to.should == [obj.user.email]
  end

  it 'renders the sender email' do
    mail.from.should == [Settings.portal_email]
  end

  it 'renders board name and user login' do
    mail.body.encoded.should match(obj.title)
    mail.body.encoded.should match(obj.user.login)
  end
end
