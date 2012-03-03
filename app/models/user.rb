class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :fb_id, :presence => true, :uniqueness => true

  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed

  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  has_and_belongs_to_many :apps

  def follow(followed)
    following << followed unless followed.nil? || following.include?(followed)
  end

  def unfollow(followed)
    following.delete(followed) unless followed.nil? 
  end
end
