require 'will_paginate'

class Api::V1::BaseController < ActionController::Base
  respond_to :json

  private
  def current_site
    SiteFinder.find_site request
  end

  def time_range
    since = convert_unix_time params[:since_date], Time.parse('01.01.2005')
    till = convert_unix_time params[:till_date], Time.now
    [since, till]
  end

  def convert_unix_time unix_time, default_time
    unix_time ? Time.at(unix_time.to_i) : default_time
  end
end