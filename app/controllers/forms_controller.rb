# encoding : utf-8
class FormsController < ApplicationController
  def create
    @request_form = Form.new(params)
    #if verify_recaptcha(model: @request_form) && 
    #render json: @request_form
    #render json: {ads: @request_form.save}
    if @request_form.save
      flash[:notice] = 'Ваша заявка получена!'
      respond_to do |format|
        format.json { render json: { flash: flash.discard }, status: :ok }
      end
    else
      flash[:alert] = 'Возникли ошибки'
      respond_to do |format|
        format.json { render json: { flash: flash.discard }, status: :unprocessable_entity }
      end
    end
  end

end
