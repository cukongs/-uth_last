module ApplicationHelper
  def rest_client(address)
    RestClient::Resource.new(
      address,
      :verify_ssl =>  false
    )
  end

  def is_in_division(user, divisions)
    return false if !user.positions.present?

    positions = JSON.parse(user.positions)["positions"]

    result = false
    divisions.each do |division|
      if positions.any? { |position| position["divisi"]["id"] == division }
        result = true
        break
      end
    end

    result
  end

  def get_username(user)
    user.username.gsub(/[.]/, "_")
  end

  def update_user_positions(user)
    username = get_username(user)

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}/employee_positions.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    user.positions = response.to_s

    user.save
  end

  def update_user_members(user)
    username = get_username(user)

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}/members.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    user.members = response.to_s

    user.save
  end

  def update_user_name(user)
    username = get_username(user)

    response = rest_client(CONFIG["virtualhr_api"])["/employees/#{username}.json?auth_token=" + CONFIG["virtualhr_auth_token"]].get
    details = JSON.parse(response.to_s)
    user.full_name = details["employee"]["nama"]
  end

  def update_user(user)
    username = get_username(user)

    if !user.authentication_token.present?
      user.authentication_token = SecureRandom.hex
    end

    update_user_positions(user)
    update_user_members(user)
    update_user_name(user)

    user.save
  end
end
