require 'spec_helper'

describe "Challenge Creation" do

  subject { page }

  describe "challenge creation page" do 
    before { visit new_challenge_path }

    it { should have_h1('Create a Challenge') }
    it { should have_title('Create a Challenge') }
    it { should have_label("Name") }
    it { should have_label("Description") }
    it { should have_label("Public?") }
  end

  describe "creation" do
    let(:parent) { FactoryGirl.create(:parent) }
    before do
      sign_in(parent)
      visit new_challenge_path
    end

    let(:submit) { "Create Challenge" }

    describe "with invalid information" do
      it "should not create a challenge" do
        expect { click_button submit }.not_to change(Challenge, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example Challenge"
        fill_in "Description",  with: "Example Challenge Description"
      end

      it "should create a challenge" do
        expect { click_button submit }.to change(Challenge, :count).by(1)
      end

      describe "after saving the challenge" do
        before { click_button submit }
        let(:challenge) { Challenge.find_by_name('Example Challenge') }

        it { should have_title(challenge.name) }
        it { should have_h1(challenge.name) }
        it { should have_success_message('You')}
      end
    end
  end
end

describe "Challenges view" do
  subject { page }

  let(:parent) { FactoryGirl.create(:parent) }
  let(:public_challenge) { FactoryGirl.create(:challenge, parent_id: parent.id, public: true) }
  let(:private_challenge) { FactoryGirl.create(:challenge, parent_id: parent.id, public: false) }
  before { public_challenge.save }
  before { private_challenge.save }

  describe "Community Pool" do
    before { visit community_pool_path }

    it { should have_h1('Community Pool') }
    it { should have_title('Community Pool') }
    it { should have_content(public_challenge.name) }
    it { should_not have_content(private_challenge.name) }
  end

  describe "Your" do
    before { sign_in parent }
    before { visit challenges_your_path }

    it { should have_title('Your') }
    it { should have_h1('Your challenges') }
    it { should have_content(private_challenge.name) }
    it { should have_content(public_challenge.name) }
  end
end
