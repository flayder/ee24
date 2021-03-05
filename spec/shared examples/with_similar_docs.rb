shared_examples_for 'with similar docs' do
  it 'should return similar_doc' do
    doc.similar_docs.should eq([similar_doc])
  end
end