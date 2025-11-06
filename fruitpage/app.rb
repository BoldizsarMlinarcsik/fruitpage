require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'

get('/') do
  slim(:home)
 
end

get('/fruits/new') do
  slim(:"fruits/new")
end

get('/animals/new') do
  slim(:"animals/new")
end

post('/fruit') do 
  new_fruit = params[:new_fruit] 
  amount = params[:amount].to_i 
  db = SQLite3::Database.new('db/fruits.db') 
  db.execute("INSERT INTO fruits (name, amount) VALUES (?,?)",[new_fruit,amount])
  redirect('/fruits')
end

post('/animal') do 
  new_animal = params[:new_animal] 
  amount = params[:amount].to_i 
  db = SQLite3::Database.new('db/animals.db') 
  db.execute("INSERT INTO animals (name, amount) VALUES (?,?)",[new_animal,amount])
  redirect('/animals')
end

post('/fruits/:id/update') do
  id = params[:id].to_i
  name = params[:name]
  amount = params[:amount].to_i
  db = SQLite3::Database.new('db/fruits.db')
  db.execute("UPDATE fruits SET name=?,amount=? WHERE id=?",[name,amount,id])
  redirect('/fruits')
end

post('/animals/:id/update') do
  id = params[:id].to_i
  name = params[:name]
  amount = params[:amount].to_i
  db = SQLite3::Database.new('db/animals.db')
  db.execute("UPDATE animals SET name=?,amount=? WHERE id=?",[name,amount,id])
  redirect('/animals')
end

get('/fruits/:id/edit') do
  
  db = SQLite3::Database.new('db/fruits.db')
  db.results_as_hash = true
  id = params[:id].to_i
  @special_fruit = db.execute("SELECT * FROM fruits WHERE id = ?", id).first
  slim(:"fruits/edit")

end

get('/animals/:id/edit') do
  db = SQLite3::Database.new('db/animals.db')
  db.results_as_hash = true
  id = params[:id].to_i
  @special_animal = db.execute("SELECT * FROM animals WHERE id = ?", id).first
  slim(:"animals/edit")
end

post('/fruits/:id/delete') do
  delete = params[:id].to_i
  db = SQLite3::Database.new('db/fruits.db')
  db.execute("DELETE FROM fruits WHERE id=(?)",delete)
  redirect('/fruits')
end

post('/animals/:id/delete') do
  delete = params[:id].to_i
  db = SQLite3::Database.new('db/animals.db')
  db.execute("DELETE FROM animals WHERE id=(?)",delete)
  redirect('/animals')
end
 

get('/fruits') do
  #@fruits = ["Äpple", "Apelsin", "Banan", "Plummon", "Päron", "Mango", "Jordgubbar", "Persika"] 
  query = params[:q]
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  p "Jag skrev #{query}!"

  if query && !query.empty?
    #hämta det som användaren söker från db, 
    @datafrukt = db.execute("SELECT * FROM fruits WHERE name LIKE ?","%#{query}%")
  else
    #annars hämta allting från db!
    @datafrukt = db.execute("SELECT * FROM fruits")
    
  end
  
  slim(:"fruits/index")
end

get('/animals') do
  query = params[:q]
  db = SQLite3::Database.new("db/animals.db")
  db.results_as_hash = true
  p "Jag skrev #{query}!"
  if query && !query.empty? 
    @datadjur = db.execute("SELECT * FROM animals WHERE name LIKE ?","%#{query}%")
  else
    @datadjur = db.execute("SELECT * FROM animals")
    
  end
  
  slim(:"animals/index")
end


get('/fruits/:fruit_id') do
  list = ["Äpple", "Apelsin", "Banan", "Plummon", "Päron", "Mango", "Jordgubbar", "Persika"]
	
  @info = [
    {
    "fruit" => "Äpple",
    "color" => "Röd"
    },
    {
    "fruit" => "Apelsin",
    "color" => "Orange"
    },
    {
    "fruit" => "Banan",
    "color" => "Gul"
    },
    {
    "fruit" => "Plummon",
    "color" => "Rosa"
    },
    {
    "fruit" => "Päron",
    "color" => "Grön"
    },
    {
    "fruit" => "Mango",
    "color" => "Orange"
    },
    {
    "fruit" => "Jordgubbar",
    "color" => "Röd"
    },
    {
    "fruit" => "Persika",
    "color" => "Gul"
    }
  ]

  @fruit = list[params[:fruit_id].to_i-1]

  slim(:spec_fruit)
end