class Collaborator < ActiveRecord::Base
  belongs_to :wiki
  belongs_to :user

  attr_accessor :active
end
