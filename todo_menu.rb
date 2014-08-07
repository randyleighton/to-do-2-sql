require 'pg'
require './lib/task'
require './lib/list'

DB = PG.connect({:dbname => 'to_do'})

def main_menu
  loop do
    puts "[ == Task List Main Menu ==]"
    puts "[z] clear the databases"
    puts "[c] Create a new List"
    # puts "[l] View Lists"
    puts "[a] Add Tasks"
    puts "[d] Delete a Task"
    puts "[x] Exit home"
    puts "[l] List Tasks"
    menu_choice = gets.chomp
    if menu_choice == 'a'
      add_task
    elsif menu_choice == 'c'
      create_list
    elsif menu_choice == 'l'
      list_tasks
    elsif menu_choice == 'd'
      delete_task
    elsif menu_choice == 'z'
       detonate
    elsif menu_choice == 'x'
      puts "Thanks."
      exit
    else
      puts "Choose again."
    end
  end
end

def create_list
# List.new("Stuff",1).save
# @current_list = List.all.last
# puts "Happiness is: #{@current_list.name}"
end

def add_task
  puts "\n\nEnter task for the list: "
  task_choice = gets.chomp
  Task.new({:name => task_choice, :list_id => 1}).save
  puts "\nYour task has been entered."
  puts "#{Task.all.last.name}\n\n"
end

def list_tasks
  puts "\nHere is a list of all your tasks."
  Task.all.each_with_index do |task, index|
    puts "[#{index + 1}]  #{task.name}"
  end
  puts "\n\n"
end

def delete_task
  list_tasks
  puts "\n\nPress the number of the task you would like to delete."
  delete_choice = gets.chomp
end

def detonate
  DB.exec("DELETE FROM tasks *;")
  DB.exec("DELETE FROM lists *;")
end

main_menu
