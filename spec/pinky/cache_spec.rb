require File.expand_path '../../spec_helper', __FILE__
require 'date'

module Pinky
  describe Cache do
    let(:cache) { Cache.new([:id, :name], 100) }

    context 'Cache#name_for' do
      it { Cache.name_for(:id).should == 'cache_by_id' }
      it { Cache.name_for(:id, :name).should == 'cache_by_id_and_name' }
      it { Cache.name_for(:name, :id).should == 'cache_by_id_and_name' }
      it { cache.name.should == 'cache_by_id_and_name' }
    end

    context 'as a cache' do
      it 'should be able to add and read an item' do
        item = mock(:id => 123, :name => 'joel')
        cache.empty?.should be_true
        cache.update_with(item, :create)
        cache.empty?.should be_false
      end

      it 'should update cache' do
        item = mock(:id => 123, :name => 'joel', :foo => 'first')
        cache.update_with(item, :create)
        item = mock(:id => 123, :name => 'joel', :foo => 'second')
        cache.update_with(item, :update)

        cache.size.should == 1
        cache.query(:id => 123, :name => 'joel').foo.should == 'second'
      end

      it 'should remove from cache' do
        item = mock(:id => 123, :name => 'joel', :foo => 'first')
        cache.update_with(item, :create)
        cache.update_with(item, :destroy)
        cache.empty?.should be_true
      end

      it 'should only store 20 items if capacity is capped at 20' do
        cache = Cache.new([:id, :name], 2)
        10.times {|i| cache.update_with(mock(id: i, name: 'foo'), :create) }
        cache.send(:cache).size.should == 2
      end

      it 'orders most recently used items ordered by usage' do
        cache = Cache.new([:id, :name], 5)
        10.times do |i|
          cache.update_with(mock(id: i, name: 'foo'), :create)
          cache.query(:id => 5, :name => 'foo')
          cache.query(:id => 7, :name => 'foo')
        end
        cache.send(:cache).keys.last(2).should == ['5.foo', '7.foo']
      end
    end

    context 'queryable' do
      let (:cache_hit_query) { { :name => 'guy', :id => 123 } }
      let (:cache_miss_query) { { :id => 123 } }

      it 'should respond as being queryable' do
        cache.queryable_for?(cache_hit_query).should be_true
      end

      it 'should respond as not being queryable' do
        cache.queryable_for?(cache_miss_query).should be_false
      end
    end
  end
end
