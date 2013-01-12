require 'spec_helper'

describe "Parent pages" do

  subject { page }

  describe "index" do

    let(:parent) { FactoryGirl.create(:parent) }

    before(:each) do
      sign_in parent
      visit parents_path
    end

    it { should have_selector('title', text: 'All parents') }
    it { should have_selector('h1',    text: 'All parents') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:parent) } }
      after(:all)  { Parent.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each parent" do
        Parent.paginate(page: 1).each do |parent|
          page.should have_selector('li', text: parent.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin parent" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit parents_path
        end

        it { should have_link('delete', href: parent_path(Parent.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(Parent, :count).by(-1)
        end
        it "should not be able to delete himself" do
          page.should_not have_link('delete', href: parent_path(admin))
        end
      end
    end
  end
  
  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
    let(:parent) { FactoryGirl.create(:parent) }
    before { visit parent_path(parent) }

    it { should have_selector('h1',    text: parent.name) }
    it { should have_selector('title', text: parent.name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a parent" do
        expect { click_button submit }.not_to change(Parent, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example Parent"
        fill_in "Email",        with: "parent@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a parent" do
        expect { click_button submit }.to change(Parent, :count).by(1)
      end

      describe "after saving the parent" do
        before { click_button submit }
        let(:parent) { Parent.find_by_email('parent@example.com') }

        it { should have_selector('title', text: parent.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome' ) }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:parent) { FactoryGirl.create(:parent) }
    before do
      sign_in parent
      visit edit_parent_path(parent)
    end

    describe "page" do
      it { should have_selector('h1', text: 'Update your profile') }
      it { should have_selector('title', text: 'Edit parent') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: parent.password
        fill_in "Confirm Password", with: parent.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { parent.reload.name.should  == new_name }
      specify { parent.reload.email.should == new_email }
    end
  end
end
