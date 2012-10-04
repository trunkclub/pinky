require File.expand_path '../../spec_helper', __FILE__

module Pinky
  describe Associations do
    class Employee; end
    class FooBar; end
    member_klass = Class.new do
      extend Associations

      has_one Employee
      has_one FooBar, :lookup_by => :employee_id

      attr_reader :employee_id
      def initialize employee_id
        @employee_id = employee_id
      end
    end


    it 'looks up employee by employee_id' do
      member = member_klass.new 123
      Employee.should_receive(:find).with(123)
      FooBar.should_not_receive(:find)

      member.employee
    end

    it 'looks up FooBar by employee_id' do
      member = member_klass.new 999
      FooBar.should_receive(:find).with(999)
      Employee.should_not_receive(:find)

      member.foobar
    end
  end
end
