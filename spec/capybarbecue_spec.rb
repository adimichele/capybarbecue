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
      Capybarbecue.activate!
    end
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
  end
  
  describe '#deactivate' do
    before { Capybarbecue.activate! }
    subject { Capybarbecue.deactivate! }
    it 'restores #current_session' do
      subject
      expect(Capybarbecue).to_not be_activated
      expect(Capybara.current_session).to be_an_instance_of Capybara::Session
    end
    it 'deletes #original_session' do
      subject
      expect(Capybara.methods).to_not include :original_session
    end
  end
end
