require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capybarbecue do
  describe '#activated' do
    subject{ Capybarbecue.activated? }
    it 'is true because spec_helper activates it' do
      expect(subject).to be_true
    end
    context 'when deactivated' do
      before{ Capybarbecue.deactivate! }
      it 'is false' do
        expect(subject).to be_false
      end
    end
  end
  describe '#activate' do
    before do
      Capybarbecue.deactivate!
    end
    subject{ Capybarbecue.activate! }
    after{ Capybarbecue.deactivate! }
    it 'redefines Capybara#current_session' do
      subject
      expect(Capybara.current_session).to be_an_instance_of Capybarbecue::AsyncDelegateClass
      expect(Capybara.current_session.instance).to be Capybara.original_session
    end
    it 'saves old Capybara#current_session Capybara#original_session' do
      subject
      expect(Capybara.original_session).to be_an_instance_of Capybara::Session
    end
    it 'clears the session pool' do
      Capybara.current_session
      Capybara.send(:session_pool).should_not be_empty
      subject
      Capybara.send(:session_pool).should be_empty
    end
    it 'inserts Capybarbecue::Server as the app' do
      old_app = Capybara.app
      subject
      expect(Capybara.app).to be_an_instance_of Capybarbecue::Server
      expect(Capybara.app.app).to be old_app
    end
  end
  
  describe '#deactivate' do
    before { Capybarbecue.activate! }
    subject { Capybarbecue.deactivate! }
    after { Capybarbecue.activate! }
    it 'restores #current_session' do
      subject
      expect(Capybarbecue).to_not be_activated
      expect(Capybara.current_session).to be_an_instance_of Capybara::Session
    end
    it 'deletes #original_session' do
      subject
      expect(Capybara.methods).to_not include :original_session
    end
    it 'restores the server app' do
      subject
      expect(Capybara.app).to_not be_an_instance_of Capybarbecue::Server
    end
    it 'clears the session pool' do
      Capybara.current_session
      Capybara.send(:session_pool).should_not be_empty
      subject
      Capybara.send(:session_pool).should be_empty
    end
  end
end
