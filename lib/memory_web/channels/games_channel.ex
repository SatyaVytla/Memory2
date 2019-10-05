defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel
    alias Memory.Game
    alias Memory.BackupAgent

    def join("games:" <> name, payload, socket) do
       if authorized?(payload) do
         game = BackupAgent.get(name) || Game.new()
         socket = socket
         |> assign(:game, game)
         |> assign(:name, name)
         BackupAgent.put(name, game)
         {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
       else
         {:error, %{reason: "unauthorized"}}
       end
     end

     def handle_in("onClick", %{"id" => ll}, socket) do
        name = socket.assigns[:name]
       game = Game.onClick(socket.assigns[:game], ll)
       socket = assign(socket, :game, game)
       BackupAgent.put(name, game)
       {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
     end

     def handle_in("onClick2", %{"id" => ll}, socket) do
     name = socket.assigns[:name]
       game = Game.onClick2(socket.assigns[:game], ll)
       socket = assign(socket, :game, game)
       BackupAgent.put(name, game)
       {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
     end

     def handle_in("onHandleReset", socket) do
     name = socket.assigns[:name]
       game = Game.onHandleReset(socket.assigns[:game])
       socket = assign(socket, :game, game)
       BackupAgent.put(name, game)
       {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
     end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
