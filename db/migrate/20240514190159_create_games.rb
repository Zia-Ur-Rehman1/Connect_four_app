class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.text :state
      t.integer :current_player
      t.integer :winner

      t.timestamps
    end
  end
end
