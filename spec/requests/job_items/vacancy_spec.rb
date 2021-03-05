# encoding:utf-8
require 'spec_helper'

describe 'Vacancy' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user, site: site }
  let!(:job_section) { create :job_section }
  let!(:site_section) { create :site_section, site: site, section: job_section }
  let!(:industry) { create :industry, site: site }
  let!(:profession) { create :profession, industry: industry, site: site }

  context 'on job page' do
    let!(:vacancy) { create :vacancy, :approved, user: current_user, professions: [profession] }
    let!(:board_photo) { create :board_photo, photoable: vacancy }

    before do
      visit job_path
    end

    it 'shows vacancy on the page' do
      page.should have_content(vacancy.title)
    end

    it 'has photos' do
      page.should have_xpath(%(//img[@src="#{vacancy.photos.first.image.url(:small)}\"]))
    end
  end

  describe 'adding new vacancy' do
    def submit_vacancy
      fill_in "vacancy_company_name", with: vacancy_fields[:company_name]
      within '#vacancy_industry_id' do
        find(:css, "option[value='#{industry.id}']").select_option
      end
      page.should have_selector('div#professions input')
      find(:css, 'div#professions input').set(true)
      fill_in "vacancy_title", with: vacancy_fields[:title]
      fill_in "vacancy_text", with: vacancy_fields[:text]
      fill_in "vacancy_contacts", with: vacancy_fields[:contacts]
      attach_file("vacancy_photos_attributes_0_image", fixture_file_path("ava.jpg"))
      find(:css, 'input.submit').click
    end

    let(:vacancy_fields) { attributes_for(:vacancy) }

    before do
      Rails.cache.clear
      login(current_user)
      visit_with_port new_vacancy_path
    end

    it 'shows new vacancy', js: true do
      submit_vacancy
      page.current_path.should eq(vacancies_path)

      Vacancy.count.should eq(1)
      Vacancy.last.should have(1).photos
    end
  end
end
