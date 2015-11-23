class UsersController < ApplicationController
  include ApplicationHelper

  before_action :doorkeeper_authorize!

  def index
  end

  def me
    user = User.find(doorkeeper_token.resource_owner_id)
    username = user.username.gsub(/[.]/, "_")

    if !user.authentication_token.present?
      user.authentication_token = SecureRandom.hex
    end

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}/employee_positions.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    positions = JSON.parse(response.to_s)
    user.positions = positions.to_s

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}/members.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    members = JSON.parse(response.to_s)
    user.members = members.to_s

    user.save

    render json: user.as_json
  end
end
