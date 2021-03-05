# encoding:utf-8
require 'spec_helper'

describe 'Catalog' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user }
  let!(:catalog_rubric) { create :catalog_rubric, site: site }
  let!(:child_catalog_rubric) { create :catalog_rubric, parent: catalog_rubric, site: site }
  let!(:catalog_attributes) { create(:catalog, site: site).attributes.merge({ catalog_rubric_id: create(:catalog).rubric.id }) }
  let!(:catalog_section) { create :section, controller: 'catalog' }
  let!(:site_section) { create :site_section, site: site, section: catalog_section }

  before do
    Rails.cache.clear
  end

  context 'when user' do
    let(:catalog_fields) { attributes_for(:catalog) }
    let(:catalog) { Catalog.last }

    before do
      login current_user
      visit_with_port(new_catalog_path)
    end

    it 'creates proper catalog', js: true do
      within 'form#new_catalog' do
        fill_user_accessible_fields(catalog_fields)
        find(:xpath, 'input[@type="submit"]').click
      end

      page.current_path.should eq("/catalog")

      check_user_accessible_fields(catalog, catalog_fields)
    end
  end

  context 'when editor' do
    let(:catalog_fields) { attributes_for(:catalog, :with_editor_fields) }
    let!(:site_admin) { create :site_editor, site: site, user: current_user }
    let!(:permission) { create :permission, site_admin: site_admin,
                               section: catalog_section}
    let(:catalog) { Catalog.last }

    before do
      login current_user
      visit_with_port(new_catalog_path)
    end

    it 'creates proper catalog', js: true do
      # TODO: добавить в форму выбор галлереи из списка
      within 'form#new_catalog' do
        fill_user_accessible_fields(catalog_fields)
        fill_editor_accessible_fields(catalog_fields)
        find(:xpath, 'input[@type="submit"]').click
      end

      page.current_path.should eq("/catalog")

      check_user_accessible_fields(catalog, catalog_fields)
      check_editor_accessible_fields(catalog, catalog_fields)
    end
  end

  def fill_user_accessible_fields(catalog_fields)
    within '#catalog_catalog_rubric_id' do
      find(:css, "option[value='#{child_catalog_rubric.id}']").select_option
    end
    fill_in 'catalog_title', with: catalog_fields[:title]
    fill_in 'catalog_email', with: catalog_fields[:email]
    fill_in 'catalog_tel', with: catalog_fields[:tel]
    fill_in 'catalog_site_url', with: catalog_fields[:site_url]
    fill_in 'catalog_fax', with: catalog_fields[:fax]
    fill_in 'catalog_postal_code', with: catalog_fields[:postal_code]
    fill_in 'catalog_region_extension', with: catalog_fields[:region_extension]
    fill_in 'catalog_locality', with: catalog_fields[:locality]
    fill_in 'catalog_street_address', with: catalog_fields[:street_address]
    fill_in 'catalog_extended_address', with: catalog_fields[:extended_address]
    attach_file("catalog_logo", fixture_file_path("ava.jpg"))
    fill_in 'catalog_annotation', with: catalog_fields[:annotation]
  end

  def fill_editor_accessible_fields(catalog_fields)
    fill_in_ckeditor 'catalog_text', with: catalog_fields[:text]
    fill_in 'catalog_contact', with: catalog_fields[:contact]
    fill_in 'catalog_meta_title', with: catalog_fields[:meta_title]
    fill_in 'catalog_meta_keywords', with: catalog_fields[:meta_keywords]
    fill_in 'catalog_meta_description', with: catalog_fields[:meta_description]
    fill_in 'catalog_position', with: catalog_fields[:position]
    check 'catalog_approved'
  end

  def check_user_accessible_fields(catalog, catalog_fields)
    catalog.title.should eq(catalog_fields[:title])
    catalog.email.should eq(catalog_fields[:email])
    catalog.tel.should eq(catalog_fields[:tel])
    catalog.site_url.should eq(catalog_fields[:site_url])
    catalog.fax.should eq(catalog_fields[:fax])
    catalog.postal_code.should eq(catalog_fields[:postal_code].to_i)
    catalog.region_extension.should eq(catalog_fields[:region_extension])
    catalog.locality.should eq(catalog_fields[:locality])
    catalog.street_address.should eq(catalog_fields[:street_address])
    catalog.extended_address.should eq(catalog_fields[:extended_address])
    catalog.annotation.should eq(catalog_fields[:annotation])
  end

  def check_editor_accessible_fields(catalog, catalog_fields)
    catalog.text.should match(catalog_fields[:text])
    catalog.contact.should eq(catalog_fields[:contact])
    catalog.meta_title.should eq(catalog_fields[:meta_title])
    catalog.meta_keywords.should eq(catalog_fields[:meta_keywords])
    catalog.meta_description.should eq(catalog_fields[:meta_description])
    catalog.position.should eq(catalog_fields[:position])
    catalog.approved.should be_true
  end
end
