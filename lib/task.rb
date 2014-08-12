require 'pg'
require 'pry'

class Task

  attr_reader(:name, :list_id, :done, :due_date)

  def initialize (attributes)
    @name = attributes[:name]
    @list_id = attributes[:list_id]
    if attributes[:done]
      @done = attributes[:done]
    else
      @done = false
    end
    if attributes[:due_date]
      @due_date = attributes[:due_date]
    end
  end

  def self.find(task_to_find)
    found_task = ''
    Task.all.each do |task|
      if task.name == task_to_find
        found_task = task
      end
    end
    found_task
  end

  def mark_complete
    DB.exec("UPDATE tasks SET complete = 'y' WHERE name = '#{self.name}';")
    @done = true
  end

  def self.find_id(find_parameter)
    tasks_found = []
    results = DB.exec("SELECT * FROM tasks WHERE list_id = '#{find_parameter}';")
    results.each do |result|
      if result['complete'] == 'y'
        @completed_result = true
      else
        @completed_result = false
      end
      tasks_found << Task.new({:name => result['name'], :list_id =>result['list_id'],
                        :done => @completed_result, :due_date =>result['due_date']})
    end
    tasks_found
  end

  def self.sort
    tasks = []
    results = DB.exec("SELECT * FROM tasks ORDER BY due_date, name;")
    results.each do |result|
      if result['complete'] == 'y'
        @completed_result = true
      else
        @completed_result = false
      end
      tasks << Task.new({:name => result['name'], :list_id =>result['list_id'].to_i,
                        :done => @completed_result, :due_date =>result['due_date']})
    end
  tasks
  end


  def self.all
    tasks = []
    results = DB.exec("SELECT * FROM tasks;")
    results.each do |result|
      if result['complete'] == 'y'
        @completed_result = true
      else
        @completed_result = false
      end
    tasks << Task.new({:name => result['name'], :list_id =>result['list_id'],
                        :done => @completed_result, :due_date =>result['due_date']})
    end
    tasks
  end

  def update_task_name(new_name)
    DB.exec("UPDATE tasks SET name ='#{new_name}' WHERE name = '#{self.name}';")
    @name = new_name
  end

  def delete
    DB.exec("DELETE FROM tasks WHERE name = '#{self.name}';")
  end

  def delete_from_list(list_num)
    DB.exec("DELETE FROM tasks WHERE list_id = #{list_num};")
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id, complete, due_date) VALUES ('#{@name}', '#{@list_id}',
            '#{@done}', '#{due_date}');")
  end

  def ==(another_task)
    if another_task.is_a?(Task)
      self.name == another_task.name && self.list_id.to_i == another_task.list_id.to_i
    else
      false
    end
  end

end
