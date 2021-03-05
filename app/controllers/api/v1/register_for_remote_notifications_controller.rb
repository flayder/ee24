class Api::V1::RegisterForRemoteNotificationsController < Api::V1::BaseController
  def initialize
    @mobile_api_key = YAML.load(File.read(Rails.root.join('config', 'app.yml')))[Rails.env]["mobile_api_key"]
  end

  before_filter :check_key, :gsub_token
  respond_to :json

  rescue_from 'ApiKeyNotValidError' do
    flash[:error] = 'wrong api key'
    respond_to do |format|
      format.json { render json: flash, status: :unprocessable_entity }
    end
  end

  # POST api/v1/mobile_devices.json
  def create
    @device =
      current_site.mobile_devices.find_or_initialize_by_token(params[:mobile_device][:token])
    @device.touch

    respond_to do |format|
      if @device.save
        format.json { render json: @device, status: :created }
      else
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def check_key
    raise ApiKeyNotValidError if request.headers["api-key"] != @mobile_api_key
  end

  class ApiKeyNotValidError < StandardError
  end

  def gsub_token
    params[:mobile_device][:token].gsub!(/[^a-zA-Z0-9\-]/,"")
  end
end
