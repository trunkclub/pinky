require File.expand_path '../../spec_helper', __FILE__

module Pinky
  describe ModelFetchMethods do
    context 'caches' do
      member_klass = Class.new do
        extend Pinky::ModelFetchMethods
        cachable_by method_names: :id

        def initialize hash; @hash = hash end
        def id; @hash[:id] end

        class << self
          def pinky_request_hostname(query)
            'http://fake.com'
          end

          def pinky_request_path(query)
            '/member'
          end

          def pinky_request_headers(query)
            { 'Accept' => 'version=1' }
          end
        end
      end

      let(:response)  {
        {:id => 4255, :token => 'fakeToken123', :first_name => 'Joel', :last_name => 'Friedman', :email => 'joel@example' }.tap { |r| r.stub(:success? => true) }
      }

      context '#find' do
        before do
          url = 'http://fake.com/member'
          HTTParty.should_receive(:get).with(url,
                                             :headers => { 'Accept' => 'version=1' },
                                             :query   => { :id      => 4255 }
                                            ).once.and_return(response)
        end

        after { member_klass.clear_caches }

        it 'not raise an exception' do
          expect { member_klass.find :id => 4255 }.to_not raise_error
        end

        it 'caches the object' do
          member_klass.find :id => 4255
          member_klass.find :id => 4255
        end
      end

    end
  end
end
