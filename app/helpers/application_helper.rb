module ApplicationHelper
  def rest_client(address)
    RestClient::Resource.new(
      address,
      :verify_ssl =>  false
    )
  end
end
