# encoding : utf-8
class RequestFormsController < ApplicationController

  def create
    @request_form = RequestForm.new(params[:request_form])
    if verify_recaptcha(model: @request_form) && @request_form.save
      flash[:notice] = 'Ваша заявка получена!'
      respond_to do |format|
        format.json { render json: { flash: flash.discard }, status: :ok }
        format.html {}
      end
    else
      flash[:alert] = 'Возникли ошибки'
      respond_to do |format|
        format.json { render json: { flash: flash.discard }, status: :unprocessable_entity }
        format.html {}
      end
    end
  end

end
