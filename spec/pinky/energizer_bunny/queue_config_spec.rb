require File.expand_path('../../../spec_helper.rb', __FILE__)

module Pinky
  module EnergizerBunny::Config
    describe Queue do
      context 'initialization' do
        let(:queue) { Queue.new(:ref_key, 'test_queue_name') }

        it 'should have a name' do
          queue.reference_key.should == :ref_key
          queue.name.should == 'test_queue_name'
        end
      end
    end
  end
end
