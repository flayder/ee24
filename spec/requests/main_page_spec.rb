# encoding:utf-8
require 'spec_helper'

describe 'Root page' do
  let!(:site) { create :prague_site }

  before do
    visit root_path
  end

  it 'should have link to login' do
    page.should have_xpath("//input[@value='Войти']")
  end

  it 'should have link to register' do
    page.should have_link('ЗАРЕГИСТРИРОВАТЬСЯ')
  end

  it 'should have link to remind password' do
    page.should have_link('ЗАБЫЛИ ПАРОЛЬ?')
  end
end
