class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
   after_initialize :add_role
   def add_role
     self.role ||= "standard" if self.role.nil?
   end

   has_many :wikis, dependent: :destroy
   has_many :collaborators, through: :wikis, dependent: :destroy
end
