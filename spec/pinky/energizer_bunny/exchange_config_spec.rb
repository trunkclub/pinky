require File.expand_path('../../../spec_helper.rb', __FILE__)

module Pinky
  module EnergizerBunny::Config
    describe Exchange do
      context 'simple initialization' do
        after { Pinky::EnergizerBunny::Configurations.clear_all }

        let(:config) { Exchange.new(:pinky_actions, 'TEST.PINKY.ACTIONS', :headers) }

        it 'should know the exchange name and reference key' do
          config.reference_key.should == :pinky_actions
          config.name.should == 'TEST.PINKY.ACTIONS'
          config.type.should == :headers
        end

        it 'should be added to the Configurations' do
          config.should == Pinky::EnergizerBunny::Configurations.exchange(:pinky_actions)
        end

        context 'default defaults' do
          it 'should default auto_delete to true' do
            config.auto_delete.should be_false
          end

          it 'should default durable to false' do
            config.durable.should be_false
          end
        end

        it 'should provide an opts hash' do
          config.opts.should == {
            :type        => :headers,
            :auto_delete => false,
            :durable     => false
          }
        end

      end

      context 'initialization with block' do
        it 'should allow you to change from defaults' do
          exchange = Exchange.new(:test_exchange, 'MY.TEST.EXCHANGE', :headers) do |e|
            e.durable.should be_false
            e.durable = true
          end
          exchange.durable.should be_true
        end
      end

      describe HeadersExchange do
        it 'sets the type to headers' do
          config = HeadersExchange.new(:ref_key, 'MY.EXCHANGE') do |ex|
            ex.durable = true
          end
          config.type.should == :headers
          config.durable.should == true
        end
      end
    end
  end
end
