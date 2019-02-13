defmodule Atlas.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :active, :boolean
      add :description, :text
      add :name, :string
      add :slug, :string
      timestamps()
    end

    create index(:features, [:active])
    create unique_index(:features, [:slug])
  end
end
