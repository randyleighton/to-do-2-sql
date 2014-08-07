require 'pg'

class Task

attr_reader(:name, :list_id)

  def initialize (attributes)
    @name = attributes[:name]
    @list_id = attributes[:list_id]
  end

  def self.all
    tasks = []
    results = DB.exec("SELECT * FROM tasks;")
    results.each do |result|
    tasks << Task.new({:name => result['name'], :list_id =>result['list_id']})
    end
    tasks
  end

  def delete

  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id) VALUES ('#{@name}', '#{@list_id}');")
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id.to_i == another_task.list_id.to_i
  end

end
