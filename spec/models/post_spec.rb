require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe Post, :type => :model do
  context "trying to make 2 posts within 1 minute" do
    it "should raise error" do
      DatabaseCleaner.clean
      
      # Create a user
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoo")
      
      # Create one post
      user.posts.create!(:title => "foobar", :url => "http://www.foobar.com")
      
      # Create another post immediately within 1 minute, expect error
      expect{
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com")
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "trying to make more than 20 posts per user" do
    it "should raise error" do
      DatabaseCleaner.clean
      
      # Create a user
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoo")

      # Make 20 posts
      for i in 1..21
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com", :created_at => Time.now - i * 2.minutes)
      end

      # Make 21th post, expect error
      expect{
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com")
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
