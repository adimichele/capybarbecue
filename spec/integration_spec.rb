require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "A real life app", :type => :feature do
  around do |spec|
    @old_app, Capybara.app = Capybara.app, TestRackApp.new
    spec.run
    Capybara.app = @old_app
  end
  it "responds to a simple request" do
    visit "/test/path"
    expect(page).to have_content "/test/path"
  end
end