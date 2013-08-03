require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capybarbecue do
  describe '#activate' do
    before do
      Capybara.current_driver = :rack_test
      Capybarbecue.activate!
    end
    after{ Capybarbecue.deactivate! }
    it 'redefines Capybara#current_session' do
      subject
      expect(Capybara.current_session.mode).to eq :capybarbecue
    end
    it 'saves old Capybara#current_session Capybara#original_session' do
      expect(Capybara.original_session.mode).to eq :rack_test
    end
  end
  
  describe '#deactivate' do
    before { Capybarbecue.activate! }
    subject { Capybarbecue.deactivate! }
    it 'restores #current_session' do
      subject
      expect(Capybara.current_session.mode).to eq :rack_test
    end
  end
end
