defmodule AccessManagment.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:permissions, [:title])
  end
end
