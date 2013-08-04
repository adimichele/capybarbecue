require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe 'With a real life app', :type => :feature, :capybara_feature => true do
  # Test that operations on nodes work as expected
  let(:path){ '/test/path'}
  before{ visit path }
  describe Capybara::Node::Element do
    subject{ find("##{id}") }
    describe '#text' do
      let(:id){ 'hidden_text' }
      its(:text){ should include 'I am text' }
    end
    describe '#[]' do
      let(:id){ 'hidden_text' }
      its(['id']){ should eq id }
    end
    describe '#value' do
      let(:id){ 'volvo' }
      its(:value){ should eq 'volvo' }
    end
    describe '#set' do
      let(:id){ 'text_field' }
      it 'sets the value of the field' do
        expect{ subject.set 'peanuts' }.to change{ subject.value }.to 'peanuts'
      end
    end
    describe '#select_option, #unselect_option, #selected?, #checked?' do
      let(:id){ 'volvo' }
      it 'selects and unselects an option' do
        expect{ subject.select_option }.to change{ subject.selected? }.from(false).to(true)
        expect{ subject.unselect_option }.to change{ subject.selected? }.from(true).to(false)
        expect(subject).to_not be_checked
      end
    end
    describe '#click' do
      let(:id){ 'link1' }
      it 'follows the link' do
        expect{ subject.click }.to change{ page.current_path }.to '/link/1'
      end
    end
    describe '#hover' do
      let(:id){ 'div1' }
      before do
        page.execute_script("document.getElementById('#{id}').onmouseover = function(){ document.write('hovered') }")
      end
      it 'triggers the hover js' do
        subject.hover
        page.should have_text 'hovered'
      end
    end
    describe '#tag_name' do
      let(:id){ 'div1' }
      its(:tag_name){ should eq 'div' }
    end
    describe '#visible?' do
      let(:id){ 'div1' }
      it{ should be_visible }
    end
    describe '#disabled?' do
      let(:id){ 'disabled_text' }
      it{ should be_disabled }
    end
    describe '#path' do
      let(:id){ 'text_field' }
      pending 'is not supported in some drivers'
    end
    describe '#trigger' do
      let(:id){ 'div1' }
      before do
        page.execute_script("document.getElementById('#{id}').onclick = function(){ document.write('sandwiches') }")
      end
      it 'triggers a click event' do
        subject.trigger 'click'
        expect(page).to have_text 'sandwiches'
      end
    end
    describe '#drag_to' do
      let(:id){ 'text_field' }
      let(:target){ find('#disabled_text') }
      it 'works?' do
        subject.drag_to target
      end
    end
    describe '#reload' do
      let(:id){ 'text_field' }
      it 'reloads the node' do
        expect(subject.reload.value).to eq 'monkeys'
      end
    end
  end
end