# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AccuWeatherService do
  subject { described_class.new }
  let(:mocked_key) { { 'Key' => 'mocked_key' } }

  describe '#get_location_key' do
    context 'when the API call is successful' do
      it 'returns the location key' do
        # Stubbing the RestClient.get method to return the mocked response
        allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(mocked_key.to_json)

        expect(subject.get_location_key).to eq('mocked_key')
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
    let(:mocked_temperature) {
      {
        'Temperature'=>{
          'Metric'=> {
            'Value'=>20.8,
            'Unit'=>'C',
            'UnitType'=>17
          },
          'Imperial'=>{
            'Value'=>69.0,
            'Unit'=>'F',
            'UnitType'=>18
          }
        },
      }
    }

    context 'when location key is valid' do
      it 'returns Temperature' do
        allow(subject).to receive(:get_location_key).and_return(mocked_key)
        mocked_key = subject.get_location_key

        allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(mocked_temperature.to_json)

        expect(subject.current_conditions(mocked_key)).to eq(mocked_temperature)
      end
    end

    context 'when an error occurs on fetching location key' do
      it 'returns nil' do
        allow(subject).to receive(:get_location_key).and_return({ error: 'key fetching error' })
        mocked_key = subject.get_location_key

        expect(subject.current_conditions(mocked_key)).to be_nil
      end
    end

  end

end