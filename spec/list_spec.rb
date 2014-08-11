require 'rspec'
require 'pg'
require 'spec_helper'
require 'list'
require 'pry'

describe List do
  it 'will initialize with a name and id' do
    new_list = List.new({:name => 'home', :id => 1})
    expect(new_list).to be_an_instance_of List
    expect(new_list.name).to eq('home')
  end

  it 'sets an id when you save it' do
    new_list = List.new({:name => 'home', :id => 1})
    new_list.save
    expect(new_list.id).to be_an_instance_of Fixnum
  end

  it 'will start with no tasks' do
    expect(List.all).to eq []
  end

  it 'is the same list if it has the same name' do
    list1 = List.new({:name => 'home', :id => 1})
    list2 = List.new({:name => 'home', :id => 1})
    expect(list1).to eq list2
  end

  it 'returns all the tasks in a given list' do
    list1 = List.new({:name => 'home'})
    list1.save
    task1 = Task.new({:name => 'learn nachos', :list_id => list1.id, :due_date => "2014-09-01"})
    task2 = Task.new({:name => 'learn nothing', :list_id => list1.id, :due_date => "2014-09-02"})
    task1.save
    task2.save
    expect(list1.tasks).to eq [task1,task2]
  end

  it 'deletes a list' do
    list1 = List.new({:name => 'home'})
    list1.save
    list2 = List.new({:name => 'work'})
    list2.save
    list1.delete
    expect(List.all).to eq [list2]
  end

  describe '.all' do
    it 'allows you to save multiple lists' do
      list1 = List.new({:name => 'work', :id => 1})
      list2 = List.new({:name => 'home', :id => 2})
      list1.save
      list2.save
      expect(List.all).to eq [list1, list2]
    end
  end

  describe '.find' do
    it 'returns the list from the database with the matching id' do
      list = List.new({:name => 'work', :id => 1})
      list.save
      expect(List.find(list.id)).to eq list
    end
  end

end


