require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe 'With a real life app', :type => :feature do
  describe Capybara::Node do
    let(:driver){ Capybara.current_session.driver }
    let(:node){ page.find("##{node_id}") }
    let(:path){ '/test/path'}
    subject{ node.base }
    before{ visit path }
    describe '#all_text' do
      let(:node_id){ 'hidden_text' }
      it 'even displays the hidden text' do
        expect(subject.all_text).to eq 'I am hidden text'
      end
    end
    describe '#visible_text' do
      let(:node_id){ 'hidden_text' }
      it 'only shows visible text' do
        expect(subject.all_text).to match /I am .*text/  # Not sure why this wants to show hidden text
      end
    end
    describe '#[]' do
      let(:node_id){ 'hidden_text' }
      it 'returns an attribute of the element' do
        expect(subject[:id]).to eq node_id
      end
    end
    describe '#value' do
      let(:node_id){ 'text_field' }
      it 'returns the value of an element' do
        expect(subject.value).to eq 'monkeys'
      end
    end
    describe '#set' do
      let(:node_id){ 'text_field' }
      it 'sets the value of a field' do
        subject.set 'bananas'
        expect(subject.value).to eq 'bananas'
      end
    end
    describe '#select_option' do
      let(:node_id){ 'volvo' }
      it 'selects an option' do
        subject.select_option
        expect(find('#select_field').value).to eq %w{volvo}
      end
    end
    describe '#unselect_option' do
      let(:node_id){ 'volvo' }
      before do
        subject.select_option
      end
      it 'unselects a select box option' do
        subject.unselect_option
        expect(subject).to_not be_selected
      end
    end
    describe '#click' do
      let(:node_id){ 'link1' }
      it 'clicks a link and visits a url' do
        subject.click
        expect(page.current_path).to eq '/link/1'
      end
    end
    describe '#tag_name' do
      let(:node_id){ 'div1' }
      it 'returns the tag name' do
        expect(subject.tag_name).to eq 'div'
      end
    end
    describe '#visible?' do
      let(:node_id){ 'div1' }
      it '' do
        expect(subject).to be_visible
      end
    end
    describe '#checked?' do
      let(:node_id){ 'checkbox_field' }
      it 'should tell me if a checkbox is checked' do
        expect(subject).to_not be_checked
      end
    end
    describe '#selected?' do
      let(:node_id){ 'saab' }
      it 'should tell me if a radio button is checked' do
        expect(subject).to_not be_selected
      end
    end
    describe '#disabled?' do
      let(:node_id){ 'disabled_text' }
      it 'should tell me if an input is disabled' do
        expect(subject).to be_disabled
      end
    end
    describe '#path' do
      let(:node_id){ 'div1' }
      pending 'does something?' do
        #puts subject.path
        # This isn't yet supported in Poltergeist...
      end
    end
    describe '#trigger' do
      let(:node_id){ 'div1' }
      before do
        page.execute_script("document.getElementById('#{node_id}').onclick = function(){ document.write('sandwiches') }")
      end
      it 'triggers a click event' do
        subject.trigger 'click'
        expect(page).to have_text 'sandwiches'
      end
    end
    describe '#==' do
      let(:node_id){ 'div1' }
      it 'tests node equivalence' do
        other = find("##{node_id}").base
        expect(subject == other).to be_true
      end
    end
  end
end