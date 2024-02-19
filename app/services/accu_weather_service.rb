# frozen_string_literals: true
require 'rest-client'

class AccuWeatherService
  def initialize
    @api_key = Rails.application.credentials.dig(:accu_weather, :api_key)
    @client = RestClient::Resource.new 'https://dataservice.accuweather.com'
  end

  # @param location[Array[Float, Float]]
  def get_location_key(location= [31.5268293, 74.3470055])
    begin
      parse_response(@client[locations_endpoint].get(params: { q: location.join(',') }))['Key']
    rescue => e
      { error: e.message.to_s }
    end
  end

  # @param key[String|Hash]
  def current_conditions(key)
    return if error? key
    parse_response @client[current_conditions_endpoint(key)].get
  end

  # @param key[String|Hash]
  def daily_forecasts(key)
    return if error? key
    parse_response @client[daily_forcast_endpoint(key)].get
  end

  private

  def parse_response(res)
    JSON.parse(res)
  end

  def error? response
    response.is_a?(Hash) and response[:error].present?
  end

  def locations_endpoint
    "/locations/v1/cities/geoposition/search?apikey=#{@api_key}"
  end

  def current_conditions_endpoint(key)
    "/currentconditions/v1/#{key}?apikey=#{@api_key}"
  end

  def daily_forcast_endpoint(key)
    "/forecasts/v1/daily/5day/#{key}?apikey=#{@api_key}"
  end

end
