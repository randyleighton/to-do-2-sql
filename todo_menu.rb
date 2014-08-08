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
    puts "[v] View Lists"
    puts ""
    puts "[t] GO to [== TASKS Menu ==]".blue
    puts "[x] Exit program".red
    menu_choice = gets.chomp
    if menu_choice == 'c'
      create_list
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
    puts "[l] List Tasks"
    # puts "[s] Set a Task Due Date"
    # puts "[m] Mark a task Complete"
    puts "[x] Exit to Main Menu".red
    menu_choice = gets.chomp
    if menu_choice == 'a'
      add_task
    elsif menu_choice == 'l'
      list_tasks
    elsif menu_choice == 'd'
      delete_task
    elsif menu_choice == 'z'
       clear_task_table
    # elsif menu_choice == 's'

    # elsif menu_choice == 'm'

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
  Task.new({:name => task_choice, :list_id => list_choice.to_i}).save
  puts "\n#{Task.all.last.name} has been entered.\n\n"
 end

def list_tasks
  system("clear")
  puts "Tasks with " + "List number".green
  puts "------------------------"
  puts "List# - Task Description"
  Task.all.each do |task|
    if task.name == "Eat Nachos"
      puts "[#{task.list_id}]  #{task.name}".bg_cyan
    elsif task.name == "Dance"
      puts "[#{task.list_id}]  #{task.name}".bg_magenta
    else
      puts "[#{task.list_id}]  #{task.name}"
    end
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
  Task.all.each do |task|
    if list_choice == found_list.id.to_i
      puts "#{task.name}"
    end
  end
  puts "\n\nType name of task to delete "
  task_name = gets.chomp
  task_to_delete = Task.find(task_name)
  task_to_delete.delete
end

def clear_task_table
  DB.exec("DELETE FROM tasks *;")
end

def clear_list_table
  DB.exec("DELETE FROM lists *;")
end


main_menu
