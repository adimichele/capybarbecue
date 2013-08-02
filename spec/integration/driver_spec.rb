require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe 'With a real life app', :type => :feature do
  describe Capybara::Driver do
    subject{ Capybara.current_session.driver }
    let(:path){ '/test/path'}
    before{ visit path }
    describe '#current_url' do
      it 'should get the correct url' do
        expect(subject.current_url).to end_with path
      end
    end
    describe '#visit' do
      it 'should visit the correct url' do
        visit '/another/path'
        expect(subject.current_url).to end_with '/another/path'
      end
    end
    describe '#find_xpath' do
      it 'should find a node' do
        expect(subject.find_xpath('//h1')).not_to be_empty
      end
    end
    describe '#find_css' do
      it 'should find a node' do
        expect(subject.find_css('.divclass1')).not_to be_empty
      end
    end
    describe '#html' do
      it 'should return the page html' do
        expect(subject.html).to match /<html>.*<\/html>/m
      end
    end
    describe '#execute_script' do
      it 'should execute some javascript' do
        subject.execute_script("document.write('it worked')")
        expect(subject.html).to match /it worked/
      end
    end
    describe '#evaluate_script' do
      it 'should execute some javascript and return the result' do
        expect(subject.evaluate_script('4 + 4')).to eq 8
      end
    end
    describe '#save_screenshot' do
      let(:path){ './tmp/test' }
      let(:file){ 'ss.png' }
      before{ FileUtils.mkdir_p path }
      after{ FileUtils.rm_rf path }
      it 'saves a screenshot' do
        subject.save_screenshot(File.join(path, file))
        expect(File.exists?(File.join(path, file))).to be_true
      end
    end
    describe '#response_headers' do
      it 'returns the headers' do
        expect(subject.response_headers['Content-Type']).to eq 'text/html'
      end
    end
    describe '#status_code' do
      it 'is 200' do
        expect(subject.status_code).to eq 200
      end
    end
    describe '#within_frame' do
      it 'searches inside the frame' do
        subject.within_frame('myframe') do
          expect(page).to have_css '#inframe'
        end
      end
    end
    describe '#within_window' do
      let(:name){ 'pane' }
      let(:content){ 'i am an open window' }
      before do
        page.execute_script("window.open(null,'#{name}').document.write('#{content}')")
      end
      it 'searches inside the window' do
        subject.within_window(name) do
          expect(page.html).to match /#{content}/
        end
      end
    end
  end
end