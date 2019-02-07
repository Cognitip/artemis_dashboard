defmodule AtlasLog.EventLog do
  use AtlasLog.Schema

  schema "event_logs" do
    field :action, :string
    field :meta, :map
    field :user_id, :integer
    field :user_name, :string

    timestamps()
  end

  # Callbacks

  def updatable_fields, do: [:action, :meta, :user_id, :user_name]

  def required_fields, do: [:action, :user_id, :user_name]

  # Changesets

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, updatable_fields())
    |> validate_required(required_fields())
  end
end
