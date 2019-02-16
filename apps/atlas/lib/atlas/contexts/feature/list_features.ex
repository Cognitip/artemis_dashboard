defmodule Atlas.ListFeatures do
  use Atlas.Context

  import Ecto.Query

  alias Atlas.Feature
  alias Atlas.Repo

  @default_page_size 25
  @default_preload []

  def call(params \\ %{}) do
    params = default_params(params)

    Feature
    |> preload(^Map.get(params, "preload"))
    |> get_records(params)
  end

  defp default_params(params) do
    params
    |> Atlas.Helpers.keys_to_strings()
    |> Map.put_new("page_size", @default_page_size)
    |> Map.put_new("preload", @default_preload)
  end

  defp get_records(query, %{"paginate" => true} = params), do: Repo.paginate(query, pagination_params(params))
  defp get_records(query, _params), do: Repo.all(query)
end
