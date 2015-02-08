require 'active_record'

ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'db.sqlite3'
)

ActiveRecord::Migration.create_table :tangos do |t|
  t.integer :number
  t.string :word
  t.timestamps
end
