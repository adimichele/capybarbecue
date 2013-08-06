require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AsyncCall do
  let(:obj) { Object.new }
  let(:method) { :nil? }
  let(:args) { [] }
  let(:block) { nil }
  subject{ AsyncCall.new(obj, method, *args, &block) }
  describe '#ready' do
    let(:method){ :test }
    before do
      stub(obj).test do
      end
    end
    it 'should be true once the response is ready' do
      expect(subject).to_not be_ready
      subject.run
      expect(subject).to be_ready
    end
  end
  describe '#wait_for_response' do
    let(:obj){ Object }
    let(:method){ :name }
    it 'returns the value' do
      subject.run
      expect(subject.wait_for_response).to eq 'Object'
    end
    context 'with a block' do
      it 'calls the block repeatedly while waiting' do
        mock(obj).foo.at_least(2)
        begin
          subject.wait_for_response(0.5) { obj.foo }
        rescue Timeout::Error
        end
      end
    end
    context 'when the timeout expires' do
      it 'raises an error' do
        expect{ subject.wait_for_response(0.01) }.to raise_error Timeout::Error
      end
    end
    context 'when the call raises an exception' do
      let(:method){ :test }
      before do
        stub(obj).test do
          1 / 0
        end
      end
      it 'also raises the exception' do
        subject.run
        expect{ subject.wait_for_response }.to raise_error ZeroDivisionError
      end
    end
  end
  describe '#to_s' do
    let(:obj) { Object.new }
    let(:method) { :foo }
    let(:args) { [1, Object.new] }
    before{ stub(obj).foo.with_any_args }
    it 'returns the method as a string' do
      expect(subject.to_s).to eq 'Object#foo(Fixnum, Object)'
    end
    context 'with a block' do
      let(:block){ Proc.new do end }
      it 'returns the method as a string and indicates a block' do
        expect(subject.to_s).to eq 'Object#foo(Fixnum, Object) { ... }'
      end
    end
  end
end