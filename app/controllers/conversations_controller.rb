class ConversationsController < ApplicationController
  def index
    @sending_conversations = policy_scope(current_user.sending_conversations)
    @receiving_conversations = policy_scope(current_user.receiving_conversations)
    @all_conversations = @sending_conversations + @receiving_conversations

    @messages = @all_conversations.first.messages
  end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
    authorize @conversation

    respond_to do |format|
      format.html
      format.json {
        render json: {
          conversation: @conversation,
          messages: @conversation.messages,
          current_user: current_user,
        }
      }
    end
  end
end
