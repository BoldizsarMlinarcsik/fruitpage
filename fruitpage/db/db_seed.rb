require 'sqlite3'

db = SQLite3::Database.new("fruits.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS fruits (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    amount INTEGER NOT NULL
  );
SQL

db.execute("DELETE FROM fruits")  

fruits = [
  ['Äpple',10], 
  ['Banan',20], 
  ['Apelsin',30], 
  ['Päron',40]
]

fruits.each do |fruit|
  db.execute("INSERT INTO fruits (name,amount) VALUES (?,?)", fruit)
end

puts "Seed data inlagd."