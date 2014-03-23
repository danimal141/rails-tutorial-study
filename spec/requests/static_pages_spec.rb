require 'spec_helper'

describe 'Static pages' do
  subject { page }

  describe 'Home page' do
    before { visit root_path }

    it { should have_content('Sample App') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }

    describe 'for signed_in users' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: 'hoge')
        FactoryGirl.create(:micropost, user: user, content: 'fuga')
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe 'with two or more microposts' do
        it { should have_content('microposts') }
      end

      describe 'with one micropost' do
        let(:another_user) { FactoryGirl.create(:user) }
        before do
          FactoryGirl.create(:micropost, user: another_user)
          sign_in another_user
          visit root_path
        end

        it { should_not have_content('microposts') }
        it { should have_content('micropost') }
      end
    end
  end

  describe 'Help page' do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe 'About page' do
    before { visit about_path }

    it { should have_content('About Us') }
    it { should have_title(full_title('About Us')) }
  end

  describe 'Contact page' do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }

    # use expect version (it <=> example, specify)
    # example { expect(subject).to have_title(full_title('Contact')) }
  end
end
