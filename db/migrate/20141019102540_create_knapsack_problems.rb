class CreateKnapsackProblems < ActiveRecord::Migration
  def change
    create_table :knapsack_problems do |t|
      t.text :items
      t.integer :max_cost

      t.timestamps
    end
  end
end
