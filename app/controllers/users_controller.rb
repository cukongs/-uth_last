class UsersController < ApplicationController
  include ApplicationHelper

  before_action :doorkeeper_authorize!, only: [:me]

  def index
  end

  def me
    user = User.find(doorkeeper_token.resource_owner_id)
    update_user(user)
    render json: user.as_json
  end
end
