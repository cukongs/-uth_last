class User < ActiveRecord::Base
  include ApplicationHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :ldap_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :ldap_authenticatable, :trackable, :validatable, :timeoutable

  def ldap_before_save
    user = self.username.gsub(/[.]/, "_")
    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{user}/employee_positions?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    self.email = JSON.parse(response.to_s)["email"]
  end
end
