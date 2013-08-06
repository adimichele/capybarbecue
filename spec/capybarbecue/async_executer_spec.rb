require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Capybarbecue::AsyncExecuter do
  subject { Capybarbecue::AsyncExecuter.new }
  describe '#thread' do
    it 'should be alive' do
      subject
      sleep 0.01
      expect(subject.thread).to be_alive
    end
  end
  describe '#execute' do
    let(:async_call){ AsyncCall.new(Object, :name) }
    it 'eventually executes the call' do
      subject.execute(async_call)
      expect(async_call.wait_for_response(0.1)).to eq 'Object'
    end
    context 'with nested calls' do
      let(:obj) do
        Object.new.tap do |o|
          stub(o).foo do
            subject.execute(async_call)
            async_call.wait_for_response(0.1)
          end
        end
      end
      let(:first_async_call){ AsyncCall.new(obj, :foo) }
      it 'executes both calls without deadlocking' do
        subject.execute(first_async_call)
        expect(async_call.wait_for_response(0.1)).to eq 'Object'
      end
    end
  end
  describe '#kill!' do
    it 'kills the thread' do
      expect{ subject.kill!; sleep 0.01 }.to change{ subject.thread.stop? }.from(false).to(true)
    end
  end
end