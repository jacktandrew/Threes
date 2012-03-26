class CreateAllPlayers < ActiveRecord::Migration
  def change
    create_table :all_players do |t|
      t.string :name
      t.string :password
      t.integer :purse

      t.timestamps
    end
  end
end
