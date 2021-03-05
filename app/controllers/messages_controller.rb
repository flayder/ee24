# encoding : utf-8
class MessagesController < ApplicationController
  def destroy
    message = Message.find params[:id]
    authorize! :destroy, message

    message.destroy
    redirect_to :back
  end
end
