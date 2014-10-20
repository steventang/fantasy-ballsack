class AddMaxCountToKnapsackProblems < ActiveRecord::Migration
  def change
  	add_column :knapsack_problems, :max_count, :integer
  end
end
