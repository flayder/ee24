# encoding : utf-8
class RequestFormsController < ApplicationController

  def show
    @request_form = RequestForm.new
  end

  def create
    @request_form = RequestForm.new(params[:request_form])
    #if verify_recaptcha(model: @request_form) && 
    #render json: @request_form
    #render json: {ads: @request_form.save}
    if @request_form.save
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
