# frozen_string_literal: true

class TerminalChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    p params
    p 'subscribed to channel'
    stream_from params[:id]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
