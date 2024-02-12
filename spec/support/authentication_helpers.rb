# frozen_string_literal: true
require 'rails_helper'
require 'helpers/authentication_helper'

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :feature
end
