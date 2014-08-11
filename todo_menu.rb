require 'pg'
require './lib/task'
require './lib/list'
require './lib/colors'

DB = PG.connect({:dbname => 'to_do'})

def main_menu
  system("clear")
  loop do
    puts "[== To Do List Main Menu ==]".blue
    puts "[z] clear the List Table"
    puts "[c] Create a new List"
    puts "[d] Delete a List"
    puts "[v] View Lists"
    puts ""
    puts "[t] GO to [== TASKS Menu ==]".blue
    puts "[x] Exit program".red
    menu_choice = gets.chomp
    if menu_choice == 'c'
      create_list
    elsif menu_choice == 'd'
      delete_list
    elsif menu_choice == 'v'
      view_lists
    elsif menu_choice == 'z'
       clear_list_table
     elsif menu_choice == 't'
      task_menu
    elsif menu_choice == 'x'
      puts "Thanks."
      exit
    else
      puts "Choose again."
    end
  end
end

def create_list
  puts "\n\nEnter a new list:"
  new_list = gets.chomp
  List.new({:name => new_list}).save
  puts "\n#{List.all.last.name} has been created.\n\n"
end

def delete_list
  view_lists
  puts "\n\nChoose the list [#] to delete:"
  list_choice = gets.chomp.to_i
  list_result = List.find(list_choice)
  list_result.delete
  task_result = Task.find_id(list_choice)
  task_result.each do |task|
    task.delete_from_list
  end
  view_lists
end

def view_lists
  system("clear")
  puts "Your current Task Lists: ".green
  puts "------------------------"
  puts "List ID - List Name"
  List.all.each do |list|
    puts "[#{list.id}]  #{list.name}"
  end
  puts "\n"
end

def task_menu
  system("clear")
  loop do
    puts "[ == Task Menu ==]".blue
    puts "[z] clear the task table"
    puts "[a] Add Tasks"
    puts "[d] Delete a Task"
    puts "[v] View Tasks"
    puts "[m] Mark a task Complete"
    puts "[e] edit a task description"
    puts "[x] Exit to Main Menu".red
    menu_choice = gets.chomp
    if menu_choice == 'a'
      add_task
    elsif menu_choice == 'v'
      view_tasks
    elsif menu_choice == 'd'
      delete_task
    elsif menu_choice == 'z'
      clear_task_table
    elsif menu_choice == 'm'
      mark_complete
    elsif menu_choice == 'e'
      edit_task
    elsif menu_choice == 'x'
      main_menu
    else
      puts "Choose again."
    end
  end
end

def add_task
  view_lists
  puts "\n\nChoose the list [#] to add tasks:"
  list_choice = gets.chomp.to_i
  puts "\n\nEnter Task description: "
  task_choice = gets.chomp
  puts "Enter a due date yyyy-mm-dd or hit enter for none"
  date_choice = gets.chomp
  Task.new({:name => task_choice, :list_id => list_choice.to_i,
            :done => false, :due_date => date_choice}).save
  puts "\n#{Task.all.last.name} has been entered.\n\n"
 end

def view_tasks
puts "[== View Options==]"
puts "[1] View Tasks - default order"
puts "[2] Sort by Due Date"
puts "[x] exit to [== Task Menu==]"
menu_choice = gets.chomp
if menu_choice =='1'
    list_tasks
  elsif menu_choice == '2'
    sort_date
  elsif menu_choice == '3'
    sort_date_reversed
  elsif menu_choice == 'x'
    task_menu
  end
end

def list_tasks
  system("clear")
  puts "Tasks with " + "List number".green
  puts "List# - Task Description - Complete - Due Date"
  puts "----------------------------------------------"
  Task.all.each do |task|
    puts "[#{task.list_id}] - " + "#{task.name} - " +
            "#{task.done} - " + "#{task.due_date}".green
  end
  puts "\n\n"
end



def sort_date
  system("clear")
  puts "Sort by:"
  puts "[1] Earliest due date"
  puts "[2] Latest due date"
  menu_choice = gets.chomp
  puts "Tasks with " + "List number".green
  puts "List# - Task Description - Complete - Due Date"
  puts "----------------------------------------------"
  @task_result = Task.sort
  if menu_choice == '2'
    @task_result.reverse!
  end
  @task_result.each do |task|
    puts "[#{task.list_id}] - " + "#{task.name} - " +
            "#{task.done} - " + "#{task.due_date}".green
  end
  puts "\n\n"
end






def delete_task
  view_lists
  puts "\n\nChoose the list [#] to delete a task:"
  list_choice = gets.chomp.to_i
  puts "\n\nTasks for list #{list_choice}\n"
  puts "List#".green + "Task Description"
  puts "---------------------------"
  found_list = List.find(list_choice)
  found_list.tasks.each do |tasks|
    puts "[#{tasks.list_id}] #{tasks.name}"
  end
  puts "\n\nType name of task to delete "
  task_name = gets.chomp
  task_to_delete = Task.find(task_name)
  task_to_delete.delete
end

def mark_complete
  view_lists
  puts "\n\nChoose the list [#] to mark a task complete:"
  list_choice = gets.chomp.to_i
  puts "\n\nTasks for list #{list_choice}\n"
  puts "List#".green + "Complete  Task Description"
  puts "---  --------  ----------------"
  found_list = List.find(list_choice)
  found_list.tasks.each do |tasks|
    puts "[#{tasks.list_id}] #{tasks.done} #{tasks.name} #{tasks.due_date}"
  end
  puts "\n\nType name of task to complete"
  task_name = gets.chomp
  task_to_complete = Task.find(task_name)
  task_to_complete.mark_complete
end

def clear_task_table
  DB.exec("DELETE FROM tasks *;")
end

def clear_list_table
  DB.exec("DELETE FROM lists *;")
end


main_menu
