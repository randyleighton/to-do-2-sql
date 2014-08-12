require 'rspec'
require 'pg'
require 'spec_helper'
require 'task'

describe Task do
  it 'initializes with a name and an list_id' do
    test_task = Task.new({:name => 'learn sql stuff', :list_id => 1})
    expect(test_task).to be_an_instance_of Task
  end

  it 'will tell us its name' do
    test_task = Task.new({:name => 'learn sql stuff', :list_id => 1})
    expect(test_task.name).to eq('learn sql stuff')
  end

  it 'will start with no tasks' do
    expect(Task.all).to eq []
  end

  it 'lets you save tasks to the database' do
    test_task = Task.new({:name => 'learn sql stuff', :list_id => 1, :due_date => "2014-09-01"})
    test_task.save
    expect(Task.all).to eq [test_task]
  end

  it 'is the same task if it has the same name' do
    task1 = Task.new({:name => 'learn sql stuff', :list_id => 1, :due_date => "2014-09-01"})
    task2 = Task.new({:name => 'learn sql stuff', :list_id => 1, :due_date => "2014-09-02"})
    expect(task1).to eq task2
  end

  it 'deletes tasks from the tasks table' do
    task1 = Task.new({:name => 'learn nachos', :list_id => 1, :due_date => "2014-09-01"})
    task2 = Task.new({:name => 'learn nothing', :list_id => 1, :due_date => "2014-09-02"})
    task1.save
    task2.save
    task1.delete
    expect(Task.all).to eq [task2]
  end

  it 'deletes all the tasks from a list' do
    list1 = List.new({:name => 'work'})
    list1.save
    task1 = Task.new({:name => 'learn nachos', :list_id => list1.id, :due_date => "2014-09-01"})
    task2 = Task.new({:name => 'learn nothing', :list_id => list1.id, :due_date => "2014-09-02"})
    task3 = Task.new({:name => 'learn everything', :list_id => 2, :due_date => "2014-09-03"})
    task1.save
    task2.save
    task3.save
    task1.delete_from_list(list1.id)
    expect(Task.all).to eq [task3]
  end

  it 'marks a task complete' do
    task1 = Task.new({:name => 'learn nachos', :list_id => 1, :due_date => "2014-09-01"})
    task1.save
    task1.mark_complete
    expect(task1.done).to eq true
  end

  it 'finds an object in the class array' do
    task2 = Task.new({:name => 'learn code', :list_id => 1, :due_date => "2014-09-01"})
    task2.save
    task1 = Task.new({:name => 'learn nachos', :list_id => 1, :due_date => "2014-09-02"})
    task1.save
    expect(Task.find('learn nachos')).to eq task1
  end

  it 'finds all the task objects in a list' do
    list1 = List.new({:name => 'work'})
    list1.save
    task1 = Task.new({:name => 'learn nachos', :list_id => list1.id.to_i, :due_date => "2014-09-01"})
    task2 = Task.new({:name => 'learn nothing', :list_id => list1.id.to_i, :due_date => "2014-09-02"})
    task1.save
    task2.save
    expect(Task.find_id(list1.id)).to eq [task1, task2]
  end

  it 'sorts tasks by due date' do
    task1 = Task.new({:name => 'learn nachos', :list_id => 2, :due_date => "2014-08-15"})
    task2 = Task.new({:name => 'learn nothing', :list_id => 2, :due_date => "2014-08-30"})
    task3 = Task.new({:name => 'learn everything', :list_id => 2, :due_date => "2014-08-17"})
    task1.save
    task2.save
    task3.save
    expect(Task.sort).to eq [task1, task3, task2]
  end

  it 'lets you edit the description of the task' do
    list1 = List.new({:name => 'work'})
    list1.save
    task1 = Task.new({:name => 'learn nachos', :list_id => list1.id.to_i, :due_date => "2014-09-01"})
    task1.save
    task1.update_task_name("learn to eat nachos")
    expect(task1.name).to eq 'learn to eat nachos'
    expect(Task.all.first.name).to eq 'learn to eat nachos'
  end









end
