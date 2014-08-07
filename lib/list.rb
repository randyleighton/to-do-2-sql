require 'pg'

class List

attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
    @id
  end

  def self.all
    lists = []
    results = DB.exec("SELECT * FROM lists;")
    results.each do |result|
      lists << List.new(result)
    end
    lists
  end

  def ==(another_list)
    self.name == another_list.name && self.id.to_i == another_list.id.to_i
  end
end
