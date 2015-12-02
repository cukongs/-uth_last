module ApplicationHelper
  def rest_client(address)
    RestClient::Resource.new(
      address,
      :verify_ssl =>  false
    )
  end

  def is_in_division(user, divisions)
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
end
