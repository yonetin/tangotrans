class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :user
      t.text :password
    end

  end
end
