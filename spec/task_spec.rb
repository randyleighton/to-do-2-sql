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
    test_task = Task.new({:name => 'learn sql stuff', :list_id => 1})
    test_task.save
    expect(Task.all).to eq [test_task]
  end

  it 'is the same task if it has the same name' do
    task1 = Task.new({:name => 'learn sql stuff', :list_id => 1})
    task2 = Task.new({:name => 'learn sql stuff', :list_id => 1})
    expect(task1).to eq task2
  end

  it 'deletes tasks from the database' do
    task1 = Task.new({:name => 'learn nachos', :list_id => 1})
    task2 = Task.new({:name => 'learn nothing', :list_id => 1})
    task1.save
    task2.save
    task1.delete
    expect(Task.all).to eq [task2]
  end

  it 'finds an object in the class array' do
    task2 = Task.new({:name => 'learn code', :list_id => 1})
    task2.save
    task1 = Task.new({:name => 'learn nachos', :list_id => 1})
    task1.save
    expect(Task.find('learn nachos')).to eq task1
  end

end
