require File.expand_path '../../spec_helper', __FILE__
require 'date'

module Pinky
  describe ModelFetchMethods do
    member_klass = Class.new do
      extend Pinky::ModelFetchMethods
      natural_key :id
      fetch_url 'http://fake.com/member?id=:natural_key', :response_key => 'members',
        :headers => { 'Accept' => 'version=1' },
        :query   => { 'token'  => '123' }

      def initialize hash; @hash = hash end
      def id; @hash['id'] end
    end

    before do
      @response =  {
        :success => true,
        :response => {
          :members => [
            {:id => 4255, :token => 'fakeToken123', :first_name => 'Joel', :last_name => 'Friedman', :email => 'joel@example' }
          ]
        },
        :errors => nil
      }.to_json
    end

    context '#find' do
      before do
        url = 'http://fake.com/member?id=4255'
        HTTParty.should_receive(:get).with(url,
                                           :headers => { 'Accept' => 'version=1' },
                                           :query   => { 'token'  => '123' }
                                          ).once.and_return(stub(:body => @response))
      end

      after { member_klass.clear_cache }

      it 'not raise an exception' do
        expect { member_klass.find 4255 }.to_not raise_error
      end

      it 'caches the object' do
        member_klass.find 4255
        member_klass.find 4255
      end
    end

  end
end
