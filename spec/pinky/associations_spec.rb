require File.expand_path '../../spec_helper', __FILE__

module Pinky
  describe Associations do
    class Employee; end
    class FooBar; end
    class Dude; end
    member_klass = Class.new do
      extend Associations

      has_one Employee
      has_one FooBar, :lookup_by => :employee_id
      has_one Dude, :as => :the_dude

      attr_reader :employee_id
      def initialize employee_id
        @employee_id = employee_id
      end
    end


    it 'looks up employee by employee_id' do
      member = member_klass.new 123
      Employee.should_receive(:find).with(:id => 123)
      FooBar.should_not_receive(:find)

      member.employee
    end

    it 'looks up FooBar by employee_id' do
      member = member_klass.new 999
      FooBar.should_receive(:find).with(:id => 999)
      Employee.should_not_receive(:find)

      member.foobar
    end

    it 'allows for defining the association method name' do
      member = member_klass.new 999
      member.respond_to?(:dude).should be_false
      member.respond_to?(:the_dude).should be_true
    end
  end
end
