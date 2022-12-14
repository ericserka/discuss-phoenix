defmodule Discuss.Repo.Migrations.AddUserAndTopicRelation do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :user_id, references(:users)
    end

    create index(:topics, [:user_id])
  end
end
