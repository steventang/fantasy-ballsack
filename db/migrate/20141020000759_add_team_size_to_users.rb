class AddTeamSizeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :team_size, :integer
    add_column :users, :budget, :decimal
  end
end
