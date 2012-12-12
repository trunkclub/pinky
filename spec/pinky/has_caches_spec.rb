require File.expand_path '../../spec_helper', __FILE__

module Pinky
  describe HasCaches do
    context 'with cachable_by declared' do
      klass = Class.new do
        extend Pinky::HasCaches
        cachable_by :token
        cachable_by :id, :foo

        attr_reader :id, :foo, :bar, :token
        def initialize id, foo, bar, token
          @id, @foo, @bar, @token = id, foo, bar, token
        end
      end

      it 'will create a Cache for each cachable_by' do
        caches = klass.send(:pinky_caches)
        caches.size.should == 2
      end
    end
  end
end
