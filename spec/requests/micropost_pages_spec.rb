require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe 'micropost creation' do
    before { visit root_path }

    describe 'with invalid information' do
      it 'should not create a micropost' do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end

      describe 'error messages' do
        before { click_button 'Post' }

        it { should have_content('error') }
      end

      describe 'when content is too long' do
        before do
          #fill_in 'micropost[content]', with: 'a' * 141
          fill_in 'micropost_content', with: 'a' * 141
          click_button 'Post'
        end
        it { should have_content('error') }
      end
    end

    describe 'with valid information' do
      before { fill_in 'micropost_content', with: 'Lorem ipsum' }

      it 'should create a micropost' do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe 'micropost destruction' do
    before { FactoryGirl.create(:micropost, user: user) }

    describe 'as correct user' do
      before { visit root_path }

      it 'should delete a micropost' do
        expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe 'pagination' do
    # This is deprecated behavior
    # let and subject declarations are not intended to be called...

    # before(:all) { 30.times { FactoryGirl.create(:micropost, user: user) } }
    # after(:all) { user.microposts.delete_all }

    # it { should have_selector('nav.pagination') }
    # it 'should list each microposts' do
    #   user.microposts.page(1).each do |micropost|
    #     expect(page).to have_selector('li', text: micropost.content)
    #   end
    # end

    it 'should paginate the feed' do
      30.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path

      expect(page).to have_selector('nav.pagination')
      user.microposts.page(1).each do |micropost|
        expect(page).to have_selector('li', text: micropost.content)
      end
    end
  end
end
