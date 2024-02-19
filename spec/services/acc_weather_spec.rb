# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AccuWeatherService do
  subject { described_class.new }
  let(:mocked_location) { fixture_services_file 'location.json' }
  let(:mocked_error_response) { { error: 'mocked error occurs' } }

  describe '#get_location_key' do
    context 'when the API call is successful' do
      it 'returns the location key' do
        # Stubbing the RestClient.get method to return the mocked response
        allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(mocked_location.to_json)

        expect(subject.get_location_key).to eq(mocked_location['Key'])
      end
    end

    context 'when the API call raises an exception' do
      it 'returns an error message' do
        # Stubbing RestClient.get to raise an exception
        allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise('404 Not found Exception')

        expect(subject.get_location_key).to eq({ error: '404 Not found Exception' })
      end
    end
  end

  describe '#current_conditions' do
    let(:mocked_current_conditions) { fixture_services_file 'current_conditions.json' }

    context 'when location key is valid' do
      it 'returns Temperature' do
        allow(subject).to receive(:get_location_key).and_return(mocked_location['Key'])
        mocked_key = subject.get_location_key

        allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(mocked_current_conditions.to_json)

        expect(subject.current_conditions(mocked_key)).to eq(mocked_current_conditions)
      end
    end

    context 'when error occurs on fetching location key' do
      it 'returns nil' do
        allow(subject).to receive(:get_location_key).and_return(mocked_error_response)
        mocked_key = subject.get_location_key

        expect(subject.current_conditions(mocked_key)).to be_nil
      end
    end

  end

  describe '#daily_forecasts' do
    let(:mocked_daily_forcasts) { fixture_services_file 'daily_forcasts.json' }

    context 'when location key is valid' do
      it 'returns forcasts for 5 days' do
        allow(subject).to receive(:get_location_key).and_return(mocked_location['Key'])
        mocked_key = subject.get_location_key

        allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(mocked_daily_forcasts.to_json)

        expect(subject.daily_forecasts(mocked_key)).to eq(mocked_daily_forcasts)
      end
    end

    context 'when error occurs on fetching location key' do
      it 'returns nil' do
        allow(subject).to receive(:get_location_key).and_return(mocked_error_response)
        mocked_key = subject.get_location_key

        expect(subject.daily_forecasts(mocked_key)).to be_nil
      end
    end

  end


  private

  def fixture_services_file(filename)
    json_file_path = File.join(RSpec.configuration.fixture_path, 'services/' + filename.to_s)
    JSON.parse File.read(json_file_path)
  end

end