shared_examples_for 'parameterized' do
  it { subj.title = nil; subj.should validate_presence_of(:param) }
  it { subj.should validate_presence_of(:site_id) }
  it { subj.should validate_uniqueness_of(:param).scoped_to(:site_id) }
end