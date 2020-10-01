class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if params[:listing_id].present?
      @listing = Listing.find(params[:listing_id])
      @conversation = @listing.conversations.find_or_create_by(initiating_user_id: current_user.id)
    elsif params[:conversation_id].present?
      @conversation = Conversation.find(params[:conversation_id])
    end

    @message.conversation = @conversation
    authorize @message
    if @message.save
      render json: { success: true, message: @message.content }
    else
      render json: { success: false, errors: message.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
