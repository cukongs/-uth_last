class UsersController < ApplicationController
  before_action :doorkeeper_authorize!

  def index
  end

  def me
    render json: User.find(doorkeeper_token.resource_owner_id).as_json
  end
end
