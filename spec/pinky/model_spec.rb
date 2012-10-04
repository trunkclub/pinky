require File.expand_path '../../spec_helper', __FILE__

module Pinky
  describe Model do
    member_klass = Class.new do
      include Pinky::Model
      natural_key :id

      def full_name
        "#{first_name} #{last_name}"
      end
    end

    before do
      @hash = {
        :id         => 4255,
        :token      => 'fakeToken123',
        :first_name => 'Joel',
        :last_name  => 'Friedman',
        :email      => 'joel@example.com'
      }
    end

    context 'initialization' do
      before do
        @member = member_klass.new @hash
      end

      it 'can be reconstructed from a hash' do
        expect { member_klass.new @hash }.to_not raise_error
      end

      it 'should respond to token' do 
        @member.respond_to?(:token).should be_true
        @member.token.should == 'fakeToken123'
      end

      it 'allows for methods to be created from attributes' do
        @member.full_name.should == 'Joel Friedman'
      end

      it 'knows when it was created in the the cache' do
        now = DateTime.new 2012, 05, 12, 06, 30, 22

        Timecop.freeze(now) do
          member = member_klass.new @hash
          member.cached_at.should == now
        end
      end
    end

  end
end
