module OutOfTransactions
  def self.included(base)
    base.class_eval do
      self.use_transactional_fixtures = false

      after(:each) do
        DatabaseCleaner.clean
      end
    end
  end
end
