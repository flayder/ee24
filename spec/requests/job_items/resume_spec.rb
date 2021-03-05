# encoding:utf-8
require 'spec_helper'

describe 'Resume' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user }
  let!(:job_section) { create :job_section }
  let!(:site_section) { create :site_section, site: site, section: job_section }
  let!(:industry) { create :industry, site: site }
  let!(:profession) { create :profession, industry: industry, site: site }

  context 'on job page' do
    let!(:resume) { create :resume, :approved, user: current_user, professions: [profession] }
    let!(:board_photo) { create :board_photo, photoable: resume }

    before do
      visit job_path
    end

    it 'shows resume on the page' do
      page.should have_content(resume.title)
    end

    context 'with_photo' do
      before { visit "/job/resumes/#{resume.id}" }

      it 'has photos' do
        page.should have_xpath("//img[@src=\"#{resume.photos.first.image.medium}\"]")
      end
    end
  end

  describe 'adding new resume' do
    let(:resume_fields) { attributes_for(:resume) }

    before do
      Rails.cache.clear
      login(current_user)
      visit_with_port new_resume_path
    end

    it 'creates new board with photo', js: true do
      within 'form#new_resume' do
        fill_in "resume_title", with: Faker::Company.name
        within '#resume_industry_id' do
          find(:css, "option[value='#{industry.id}']").select_option
        end
        page.should have_selector('div#professions input')
        find(:css, 'div#professions input').set(true)
        within '#resume_busy' do
          find(:css, "option[value='#{JobItem::BUSY_STATES.first[0]}']" )
        end
        fill_in "resume_money", with: resume_fields[:money]
        fill_in "resume_text", with: resume_fields[:text]
        fill_in "resume_contacts", with: resume_fields[:contacts]
        attach_file("resume_photos_attributes_0_image", fixture_file_path("ava.jpg"))
        find(:css, 'input.submit').click
      end

      page.current_path.should eq(resumes_path)

      Resume.count.should eq(1)
      Resume.last.should have(1).photos
    end
  end
end
