defmodule AtlasLog.CreateEventLog do
  use AtlasLog.Context

  alias AtlasLog.EventLog
  alias AtlasLog.Filter
  alias AtlasLog.Repo

  def call(event, %{data: data, user: user}) do
    params = %{
      action: event,
      meta: Filter.call(data),
      user_id: Map.get(user, :id),
      user_name: Map.get(user, :name)
    }

    %EventLog{}
    |> EventLog.changeset(params)
    |> Repo.insert
  end
end