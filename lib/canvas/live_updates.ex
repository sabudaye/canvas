defmodule Canvas.LiveUpdates do
  @topic inspect(__MODULE__)

  @doc "subscribe for canvas"
  def subscribe_live_view(canvas_id) do
    Phoenix.PubSub.subscribe(Canvas.PubSub, topic(canvas_id), link: true)
  end

  @doc "notify for canvas changes"
  def notify_live_view(canvas_id) do
    Phoenix.PubSub.broadcast(Canvas.PubSub, topic(canvas_id), :update)
  end

  defp topic, do: @topic
  defp topic(user_id), do: topic() <> to_string(user_id)
end
