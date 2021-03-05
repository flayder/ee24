require 'spec_helper'

describe Forecast::Widget do
  let(:widget) { create :forecast_widget }
  subject { widget }

  it { should be_valid }
  its(:location) { should be_kind_of(Forecast::Location) }
  its(:anchor) { should be_kind_of(Forecast::Anchor) }

  # describe '#destroy' do
  #   let(:anchor) { widget.anchor }

  #   it 'increments anchor limit' do
  #     expect {
  #       widget.destroy
  #     }.to change(anchor, :limit).by(1)
  #   end
  # end

  # describe 'widget object' do
  #   let(:news_doc) { create :news_doc }
  #   let!(:widget) { create :forecast_widget, url: news_doc.url(news_doc.site) }

  #   context 'when title updated' do
  #     it 'destroys widget' do
  #       expect {
  #         news_doc.update_attributes(title: (Faker::Lorem.sentence + Time.now.to_s))
  #       }.to change(Forecast::Widget, :count).by(-1)
  #     end
  #   end

  #   context 'when destroyed' do
  #     it 'destroys widget' do
  #       expect {
  #         news_doc.destroy
  #       }.to change(Forecast::Widget, :count).by(-1)
  #     end
  #   end
  # end
end
