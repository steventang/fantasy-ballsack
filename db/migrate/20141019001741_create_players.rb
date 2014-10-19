class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.decimal :value
      t.decimal :price

      t.timestamps
    end
  end
end
