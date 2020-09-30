class ConversationsController < ApplicationController
  def index
    @sending_conversations = policy_scope(current_user.sending_conversations)
    @receiving_conversations = policy_scope(current_user.receiving_conversations)
    @all_conversations = @sending_conversations + @receiving_conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
    authorize @conversation
  end
end
