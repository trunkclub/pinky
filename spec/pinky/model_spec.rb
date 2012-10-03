require File.expand_path '../../spec_helper', __FILE__

module Pinky
  describe Model do
    member_klass = Class.new do
      include Pinky::Model
      natural_key :id
      fetch_url 'http://fake.com/member/:natural_key', :response_key => 'members'
    end

    before do
      @response = '{"success":true,"response":{"members":[{"id":4255,"token":"fakeToken123","first_name":"Joel","last_name":"Friedman","email":"joel@example.com"}]},"errors":null}'
      @hash = JSON.parse '{"id":4255,"token":"fakeToken123","first_name":"Joel","last_name":"Friedman","email":"joel@example.com"}'
    end

    context '#find' do
      before do
        url = 'http://fake.com/member/4255'
        HTTParty.should_receive(:get).with(url).once.and_return(stub(:body => @response))
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

    context 'initialization' do
      it 'can be reconstructed from a hash' do
        expect { member_klass.new @hash }.to_not raise_error
      end

      context 'sucessfull initialization' do
        before do
          @gallow_member = member_klass.new @hash
        end

        it 'should respond to token' do 
          @gallow_member.respond_to?(:token).should be_true
          @gallow_member.token.should == 'fakeToken123'
        end

        it 'should create a natural key' do
          @gallow_member.natural_key.should_not be_nil
        end
      end
    end

  end
end
