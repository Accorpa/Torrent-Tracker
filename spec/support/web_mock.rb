if Rails.env.test?
  require 'webmock'
  require 'webmock/rspec'

  include WebMock::API

  WebMock.disable_net_connect!
end
