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
    test_task = Task.new({"name" => 'learn sql stuff', "list_id" => 1})
    test_task.save
    expect(Task.all).to eq [test_task]
  end

  it 'is the same task if it has the same name' do
    task1 = Task.new({:name => 'learn sql stuff', :list_id => 1})
    task2 = Task.new({:name => 'learn sql stuff', :list_id => 1})
    expect(task1).to eq task2
  end
end
