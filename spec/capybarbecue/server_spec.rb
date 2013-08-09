require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'rack'

describe Capybarbecue::Server do
  let(:app) { Object.new }
  subject{ Capybarbecue::Server.new(app) }
  before{ subject.timeout = 5 }  # This makes tests fail a little quicker
  describe '#app' do
    its(:app){ should be app }
  end
  describe '#handle_requests' do
    before{ subject.wait_for_response = false }
    it 'responds to all queued requests' do
      request1 = {}
      request2 = {}
      mock(app).call(request1)
      mock(app).call(request2)
      subject.call(request1)
      subject.call(request2)
      subject.handle_requests
    end
    context 'when Rack returns a Rack::BodyProxy object' do
      let(:body){ Rack::BodyProxy.new('body') }
      before do
        stub(app).call { [200, {}, body] }
        subject.call({})
      end
      it 'closes the BodyProxy' do
        mock(body).close
        subject.handle_requests
      end
    end
  end
  describe '#call' do
    it 'sets some env properties' do
      stub(subject).queue_and_wait
      env = {}
      subject.call(env)
      env.keys.should match_array %w{rack.multithread rack.multiprocess rack.run_once}
      env['rack.multithread'].should be_false
      env['rack.multiprocess'].should be_false
      env['rack.run_once'].should be_false
    end
    context 'when another thread handles the request' do
      before do
        stub(app).call.with_any_args { |arg| arg }
      end
      let!(:thread) do
        @thread = Thread.new do
          while true
            subject.handle_requests
            sleep 0.05
          end
        end
      end
      after { thread.kill }
      it 'gives the response' do
        env = {}
        expect(subject.call(env)).to be env
      end
      context 'when there is an exception' do
        before do
          stub(app).call.with_any_args { raise Exception.new }
        end
        it 'raises the exception' do
          expect{ subject.call('avacado') }.to raise_error
        end
      end
    end
    context 'when the timeout expires' do
      before{ subject.timeout = 0.01 }
      it 'raises an exception' do
        expect{ subject.call({}) }.to raise_error Timeout::Error
      end
    end
  end
end