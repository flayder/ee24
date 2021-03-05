require 'will_paginate'

class SemanticApi::V1::BaseController < ActionController::Base
  respond_to :json

  private
  def current_site
    SiteFinder.find_site request
  end
end
