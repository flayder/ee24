# encoding: utf-8
module Modules
  module WithSearch
    extend ActiveSupport::Concern

    included do
      include Modules::WithCommonLayout
      include Modules::WithQueryLogging

      before_filter :set_section, :get_ads
    end

    private
    def section_controller
      'search'
    end

    def search options = {}
      @broads = ["Поиск"]

      @results = ThinkingSphinx.search(*default_params(options))
      if params[:search]
        @meta_title = ["Поиск по запросу " + '"'+ "#{params[:search]}" + '". ' + Settings.portal_title + " " + Settings.portal_domain]
      else
        @meta_title = ["Поиск. #{Settings.portal_title} #{Settings.portal_domain}"]
      end

      render json: default_params(options)
    end

    def default_params options = {}
      default_hash = {
        page: params[:page],
        per_page: 9,
        with: { approved: true },
        order: 'created_at DESC'
      }
      default_hash[:page] = 112 if default_hash[:page] && default_hash[:page] > 112 #max page for ThinkingSphinx by default
      [ThinkingSphinx::Query.escape(params[:search].to_s), default_hash.deep_merge(options)]
    end

    def render_next_page
      case controller_name
      when 'docs', 'news', 'events'
        render json: {
            col1: render_json_col(@results.in_groups_of(3).transpose.first),
            col2: render_json_col(@results.in_groups_of(3).transpose.second),
            col3: render_json_col(@results.in_groups_of(3).transpose.last),
            page: @results.next_page
        }
      when 'photos'
        render json: {
            col1: render_to_string('photo/_galleries_list_extended', locals: {galleries_list_extended: @results}, layout: false, formats: [:html]),
            page: @results.next_page
        }
      when 'companies'
        render json: {
            col1: render_to_string('shared/_companies', locals: {companies: @results}, layout: false, formats: [:html]),
            page: @results.next_page
        }
      when 'vacancies'
        render json: {
            col1: render_to_string('job/_job_items', locals: {job_items: @results}, layout: false, formats: [:html]),
            page: @results.next_page
        }
      when 'dictionary_objects'
        render json: {
            col1: render_to_string('shared/_ency_items', locals: {ency_items: @results}, layout: false, formats: [:html]),
            page: @results.next_page
        }
      end
    end

    def render_json_col(col)
      render_to_string('docs/_json_articles_list', locals: {articles: col}, layout: false, formats: [:html])
    end

  end
end