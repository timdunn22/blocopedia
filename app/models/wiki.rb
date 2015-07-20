class Wiki < ActiveRecord::Base
  has_many :collaborators
  belongs_to :user
  has_many :users, through: :collaborators
  accepts_nested_attributes_for :collaborators, :allow_destroy => true

end
