class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ConversationChannel_1"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast(
      "ConversationChannel_1", message: { result: 'heyooo'}
    )
  end
end
