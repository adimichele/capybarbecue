require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Capybarbecue::AsyncDelegateClass do
  let(:obj){ Object.new }
  subject{ Capybarbecue::AsyncDelegateClass.new(obj) }

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
      expect(subject.foo).to be_an_instance_of Capybarbecue::AsyncDelegateClass
    end
    context 'when a block is given' do
      subject do
        Capybarbecue::AsyncDelegateClass.new(obj) do
          obj.wait_func
        end
      end
      it 'preserves the wait_proc' do
        mock(obj).wait_func.twice
        resp = subject.foo
        stub(resp.instance).foo
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

  context 'when a block is given' do
    subject do
      Capybarbecue::AsyncDelegateClass.new(obj) do
        obj.wait_func
      end
    end
    it 'runs the block before returning' do
      mock(obj).wait_func
      stub(obj).foo
      subject.foo
    end
  end
end