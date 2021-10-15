defmodule Aurorabot.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end


  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!penis" -> Api.create_message(msg.channel_id, "Penis!")
      "!oi" -> Api.create_message(msg.channel_id, "Ahoy!")
      _ -> :ok
    end

  end


  def handle_event(_) do
    :ok
  end

end
