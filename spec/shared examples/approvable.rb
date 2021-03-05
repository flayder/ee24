shared_examples_for 'approvable' do
  describe '#approve!' do
    # INTERESTING using Time.current leads to an error
    # because in Rails Time is ActiveSupport::TimeWithZone
    # and it is incomparable with Time and with itself
    # http://blog.tddium.com/2011/08/07/rails-time-comparisons-devil-details-etc/
    let!(:timestamp) { Time.parse Time.current.to_s }

    before do
      Timecop.freeze(timestamp)
    end

    after do
      Timecop.return
    end

    it 'sets approved' do
      expect {
        obj.approve!  
      }.to change { obj.approved }.from(false).to(true)
    end

    it 'sets approved_at' do
      expect {
        obj.approve!  
      }.to change { obj.approved_at }.from(nil).to(timestamp)
    end

    context 'mail sending' do
      before { ResqueSpec.reset! }

      it 'notifies user about moderation' do
        obj.approve!
        
        Mailer.should have_queued(
          'UserMailer',
          :approval_notification,
          obj.class.name,
          obj.id
        )
      end
    end
  end
end
