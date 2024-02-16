# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'AccuWeatherService' do
  let(:accu_weather) { AccuWeatherService.new }

  describe '#get_location_key' do
    let(:mocked_response) { { 'Key' => 'mocked_key' } }

    context 'when the API call is successful' do
      it 'returns the location key' do
        # Stubbing the RestClient.get method to return the mocked response
        allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(mocked_response.to_json)

        expect(accu_weather.get_location_key).to eq('mocked_key')
      end
    end

    context 'when the API call raises an exception' do
      it 'returns an error message' do
        # Stubbing RestClient.get to raise an exception
        allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise('404 Not found Exception')

        expect(accu_weather.get_location_key).to eq({ error: '404 Not found Exception' })
      end
    end
  end
end