class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #
  # :registerable is intentionally left out — admins are provisioned via
  # db/seeds.rb or the console, not public sign-up.
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
