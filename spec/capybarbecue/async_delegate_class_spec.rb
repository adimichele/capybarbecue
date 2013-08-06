require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Capybarbecue::AsyncDelegateClass do
  let(:obj){ Object.new }
  let(:executer){ Capybarbecue::AsyncExecuter.new }
  subject{ Capybarbecue::AsyncDelegateClass.new(obj, executer) }

  it 'calls the method on the session asynchronously' do
    mock(obj).foo{ 'cats' }
    expect(subject.foo).to eq 'cats'
  end

  context 'when the object returned is not a Capybara object' do
    before{ mock(obj).foo{ 'cats' } }
    it 'should be itself' do
      expect(subject.foo).to be_an_instance_of String
    end
  end

  context 'when the object returned is a Capybara object' do
    before { mock(obj).foo{ Capybara::Driver::Base.new } }
    it 'wraps the return value in AsyncDelegateClass' do
      expect(subject.foo).to respond_to :__async_delegate__
    end
    context 'when a block is given' do
      subject do
        Capybarbecue::AsyncDelegateClass.new(obj, executer) do
          obj.wait_func
        end
      end
      it 'preserves the wait_proc' do
        stub(obj).wait_func
        resp = subject.foo
        stub(resp.instance).foo
        mock(obj).wait_func
        resp.foo
      end
    end
  end

  describe '#instance' do
    it 'should be the instance' do
      subject.instance.should be obj
    end
  end

  describe '#respond_to?' do
    it 'returns @instance#respond_to?' do
      stub(obj).foo
      expect(subject).to respond_to :foo
    end
  end

  describe 'instance_methods of object' do
    let(:obj){ Hash.new }
    it 'delegates these to the wrapped object' do
      expect(subject).to be_a Hash
      expect(subject).to be_a_kind_of Hash
      expect(subject).to be_an_instance_of Hash
    end
  end

  describe '#__async_delegate__' do
    it 'is defined and returns true' do
      expect(subject).to respond_to :__async_delegate__
      expect(subject.__async_delegate__).to be_true
    end
  end

  context 'when a block is given' do
    subject do
      Capybarbecue::AsyncDelegateClass.new(obj, executer) do
        obj.wait_func
      end
    end
    it 'runs the block before returning' do
      mock(obj).wait_func.at_least(2)
      stub(obj).foo { sleep 0.3 }
      subject.foo
    end
  end
end