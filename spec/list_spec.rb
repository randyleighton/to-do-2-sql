require 'rspec'
require 'pg'
require 'spec_helper'
require 'list'

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
  describe '.all' do
    it 'allows you to save multiple lists' do
      list1 = List.new({:name => 'work', :id => 1})
      list2 = List.new({:name => 'home', :id => 2})
      list1.save
      list2.save
      expect(List.all).to eq [list1, list2]
    end
  end
end


