shared_examples_for 'previewable' do
  it { should respond_to(:preview_secret) }
  it { should respond_to(:preview_secret_url) }
end