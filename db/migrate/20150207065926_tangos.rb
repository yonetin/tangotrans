class Tangos < ActiveRecord::Migration
  def change
    create_table :tangos do |t|
      t.text :word
      t.text :mean1
      # t.text :mean2
      # t.text :mean3
      # t.timestamps
    end
  end
end
