require 'pg'

class List
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
    @id
  end

  def self.find(search_id)
    results = DB.exec("SELECT * FROM lists WHERE id = #{search_id};")[0]
    List.new({:name => results['name'], :id => results['id']})
  end

  def self.all
    lists = []
    results = DB.exec("SELECT * FROM lists;")
    results.each do |result|
      lists << List.new({:name => result['name'], :id => result['id']})
    end
    lists
  end

  def tasks
    tasks = []
    results = DB.exec("SELECT * FROM tasks WHERE list_id = #{self.id};")
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      if result['complete'] == 'y'
        @completed_result = true
      else
        @completed_result = false
      end
      due_date = result['due_date']
      tasks << Task.new({:name => name, :list_id => list_id,
                        :done =>@completed_result, :due_date => due_date})
    end
    tasks
  end

  def delete
    DB.exec("DELETE FROM lists WHERE id = '#{self.id}';")
  end

  def ==(another_list)
    self.name == another_list.name && self.id.to_i == another_list.id.to_i
  end

end
