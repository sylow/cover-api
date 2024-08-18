class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
    ConversationChannel.broadcast_to current_user.id, content: 'Success'
  end
end
