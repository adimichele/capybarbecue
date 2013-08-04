require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')
require 'fileutils'

# Ideally want to test everything in Capybara::Session::DSL_METHODS
# These methods haven't been tested yet:
#NODE_METHODS = [
#    :resolve, :query # These don't appear to be actual methods?
#]
#SESSION_METHODS = [
#]
#
# As methods are tested, add them to this list... it will help keep track of test coverage as Capybara changes
#NODE_METHODS = [
#    :find, :all, :first, :find_by_id, :find_button, :find_link, :find_field, :has_css?, :has_no_css?, :has_link?, :text,
#    :has_no_link?, :has_button?, :has_no_button?, :has_field?, :has_no_field?, :has_xpath?, :has_no_xpath?,
#    :has_checked_field?, :has_unchecked_field?, :has_selector?, :has_no_selector?, :assert_selector, :assert_no_selector,
#    :has_no_checked_field?, :has_no_unchecked_field?, :has_select?, :has_no_select?, :has_no_table?, :has_table?,
#    :has_content?, :has_text?, :has_no_content?, :has_no_text?, :field_labeled,
#    :click_link_or_button, :click_button, :click_link, :click_on, :fill_in, :choose, :check, :uncheck, :select, :unselect, :attach_file
#]
#SESSION_METHODS = [
#    :current_url, :current_host, :current_path, :visit, :body, :html, :source,
#    :title, :has_title?, :has_no_title?, :status_code, :response_headers,
#    :reset_session!, :current_scope, :save_page, :save_and_open_page, :save_screenshot,
#    :within, :within_fieldset, :within_table, :within_frame, :within_window,
#    :evaluate_script, :execute_script
#]
# Notes: current_scope is used extensively within Capybara

describe 'With a real life app', :type => :feature, :capybara_feature => true do
  let(:path){ '/test/path'}
  before{ visit path }
  scenario 'page properties all work' do
    expect(title).to eq 'Test Rack App'
    expect(page).to have_title 'Test Rack App'
    expect(page).to have_no_title 'Test Crack App'
    expect(current_url).to end_with '/test/path'
    expect(current_host).to include '127.0.0.1'
    expect(current_path).to eq '/test/path'
    expect(status_code).to eq 200
    expect(response_headers['Content-Type']).to eq 'text/html'
  end
  context 'with a temp dir' do
    let(:path){ './tmp/test' }
    before{ FileUtils.mkdir_p path }
    after{ FileUtils.rm_rf path }
    scenario 'we can save page screenshots and pages' do
      save_page File.join(path, 'save.html')
      save_and_open_page File.join(path, 'save_and_open.html')
      save_screenshot File.join(path, 'screenshot.png')
    end
  end
  scenario 'we can check page content' do
    expect(page).to have_content '/test/path'
    expect(page).to have_no_content '/another/path'
    expect(page).to have_text '/test/path'
    expect(page).to have_no_text '/another/path'
    expect(body).to include '/test/path'
    expect(html).to include '/test/path'
    expect(source).to include '/test/path'
    expect(text).to include '/test/path'
  end
  scenario 'we can find elements on the page' do
    expect(all('div')).to be_present
    expect(first('div')).to be_present
    expect(find('#div1')).to be_present
    expect(find_by_id('div1')).to be_present
    expect(find_button('Imma button!')).to be_present
    expect(find_link('click1')).to be_present
    expect(find_field('text_field')).to be_present
  end
  scenario 'we can check for elements on the page' do
    expect(page).to have_selector('div#div1')
    expect(page).to have_no_selector('a#div1')
    page.assert_selector 'div#div1'
    page.assert_no_selector 'a#div1'
    expect(page).to have_xpath('//div/div/a')
    expect(page).to have_no_xpath('//div/oops/a')
    expect(page).to have_css('div#div1')
    expect(page).to have_no_css('a#div1')
    expect(page).to have_link('click1')
    expect(page).to have_no_link('dontclick1')
    expect(page).to have_button('Imma button!')
    expect(page).to have_no_button('I aint no button')
    expect(page).to have_field('text_field')
    expect(page).to have_no_field('no_text_field')
    expect(page).to have_checked_field('checkbox_field2')
    expect(page).to have_no_checked_field('checkbox_field')
    expect(page).to have_unchecked_field('checkbox_field')
    expect(page).to have_no_unchecked_field('checkbox_field2')
    expect(page).to have_select('select_field')
    expect(page).to have_no_select('nota_select_field')
    expect(page).to have_table('table1')
    expect(page).to have_no_table('div1')
  end
  scenario 'we can interact with an element on the page' do
    expect{ click_link_or_button 'link2' }.to change{ current_path }.to '/link/2'
    expect{ click_on 'link1' }.to change{ current_path }.to '/link/1'
    expect{ click_link 'link2' }.to change{ current_path }.to '/link/2'
    expect{ click_button 'button1' }.to change{ current_path }.to '/button/1'
    expect{ fill_in 'text_field', with: 'red sox' }.to change{ find_field('text_field').value }.to 'red sox'
    expect{ choose 'male' }.to change{ find_field('male').checked? }.to true
    expect{ check 'checkbox_field' }.to change{ find_field('checkbox_field').checked? }.to true
    expect{ uncheck 'checkbox_field' }.to change{ find_field('checkbox_field').checked? }.to false
    expect{ page.select 'Volvo', from: 'select_field' }.to change{ find('#select_field').value }.to %w{volvo}
    expect{ unselect 'Volvo', from: 'select_field' }.to change{ find('#select_field').value }.to []
    attach_file 'file_field', File.expand_path(File.dirname(__FILE__) + '../../spec_helper.rb')
    expect(find('#file_field').value).to end_with 'spec_helper.rb'
  end
  scenario 'we can search within elements' do
    within 'div#div1' do
      expect(page).to have_css 'div.divclass2'
    end
    within_fieldset 'fieldset1' do
      expect(page).to have_field 'file_field'
    end
    within_table 'table1' do
      expect(page).to have_content 'cell 1,1'
    end
    within_frame 'myframe' do
      expect(page).to have_css '#inframe'
    end
    page.execute_script("window.open(null,'window1').document.write('i am an open window')") # create a window
    within_window 'window1' do
      expect(page.html).to have_content 'i am an open window'
    end
  end
  scenario 'we can execute javascript' do
    page.execute_script("document.write('it worked')")
    expect(html).to match /it worked/
    expect(evaluate_script('4 + 4')).to eq 8
  end
end