class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.text :title
      t.text :content
    end
  end
end
