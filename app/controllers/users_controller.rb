class UsersController < ApplicationController
  include ApplicationHelper

  protect_from_forgery except: [:sign_out]
  before_action :doorkeeper_authorize!, except: [:sign_out]

  def index
  end

  def me
    user = User.find(doorkeeper_token.resource_owner_id)
    username = user.username.gsub(/[.]/, "_")

    if !user.authentication_token.present?
      user.authentication_token = SecureRandom.hex
    end

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    details = JSON.parse(response.to_s)
    user.full_name = details["employee"]["nama"]

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}/employee_positions.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    user.positions = response.to_s

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}/members.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    user.members = response.to_s

    user.save

    render json: user.as_json
  end
end
