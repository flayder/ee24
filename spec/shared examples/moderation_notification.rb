shared_examples_for 'moderation notifiable' do
  let(:mail) { UserMailer.send(:moderation_notification, obj.class.name, obj.id) }

  it 'renders the subject' do
    mail.subject.should eq(I18n.translate("moderation_email_subjects.new_#{obj.class.name.underscore}", :title => obj.title))
  end

  it 'renders the receiver email' do
    mail.to.should == [obj.user.email]
  end

  it 'renders the sender email' do
    mail.from.should == [Settings.portal_email]
  end

  it 'renders title and user login' do
    mail.body.encoded.should match(obj.title)
    mail.body.encoded.should match(obj.user.login)
  end
end

shared_examples_for 'with moderation notification sending' do
  describe 'after_create', trunc: true do
    before do
      ResqueSpec.reset!
    end

    it 'notifies user about moderation' do
      obj = create(model)

      Mailer.should have_queued(
        'UserMailer',
        :moderation_notification,
        obj.class.name,
        obj.id
      )
    end
  end
end
