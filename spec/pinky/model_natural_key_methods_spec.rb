require File.expand_path '../../spec_helper', __FILE__
require 'date'

module Pinky
  describe Model do

    context 'with natural_key declared' do
      klass = Class.new do
        include Pinky::ModelNaturalKeyMethods
        natural_key :id, :foo
        
        attr_reader :id, :foo, :bar
        def initialize id, foo, bar
          @id, @foo, @bar = id, foo, bar
        end
      end


      it 'should create a natural key' do
        instance = klass.new(123, 'hey', 'world')
        instance.natural_key.should == '123.hey'
      end

      it 'can change the key separator' do
        klass.natural_key_separator '---'
        instance = klass.new(123, 'hey', 'world')
        instance.natural_key.should == '123---hey'
      end
    end

    context 'without natural_key declared' do
      klass = Class.new do
        include Pinky::ModelNaturalKeyMethods

        attr_reader :id
        def initialize
          @id = 123
        end
      end

      it 'should raise an error' do
        instance = klass.new
        expect { instance.natural_key }.to raise_error(Exception)
      end
    end
  end
end
