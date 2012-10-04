require File.expand_path '../../spec_helper', __FILE__
require 'date'

module Pinky
  describe CachableModel do
    member_klass = Class.new do
      extend Pinky::CachableModel
      natural_key :id

      def self.cache_hash; cache end

      def initialize hash; @hash = hash end
      def id; @hash[:id] end
      def last_name; @hash[:last_name] end
    end

    before do
      @hash = {
        :id         => 4255,
        :token      => 'fakeToken123',
        :first_name => 'Joel',
        :last_name  => 'Friedman',
        :email      => 'joel@example'
      }
    end

    after { member_klass.clear_cache }

    context 'udpate_cache' do
      it 'adds a new item to cache if action is :create' do
        member_klass.update_cache_with @hash, :create
        member_klass.cache_hash.key? 4255
      end

      it 'updates the entry if action is :update' do
        member_klass.cache_hash['4255'] = member_klass.new(@hash)
        member_klass.update_cache_with @hash.merge(:last_name => 'Foster'), :update

        member_klass.cache_hash.keys.should == ['4255']
        member_klass.cache_hash['4255'].last_name.should == 'Foster'
      end

      it 'removes the entry if action is :destroy' do
        member_klass.cache_hash['4255'] = member_klass.new(@hash)
        member_klass.update_cache_with @hash, :destroy

        member_klass.cache_hash.empty?.should be_true
      end
    end

  end
end
