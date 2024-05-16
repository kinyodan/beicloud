# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def connect
      p 'connected to main'
    end
  end
end
