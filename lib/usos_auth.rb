# frozen_string_literal: true

require_relative 'usos_auth/version'

module UsosAuth
  class Error < StandardError; end

  class Authenticator
    def initialize
      # config = Configuration.load_config
      consumer_key = 'temporary' # config['consumer_key']
      consumer_secret = 'temporary' # config['consumer_secret']
      site = 'temporary' # config['fields']
      request_token_path = 'temporary' # config['fields']
      authorize_url = 'temporary' # config['fields']
      @access_token_path = 'temporary' # config['fields']
      @callback_url = 'temporary' # config['callback_url']
      @scopes = 'temporary' # config['scopes']
      @fields = 'temporary' # config['fields']

      @consumer = OAuth::Consumer.new(
        consumer_key,
        consumer_secret,
        site: site,
        request_token_path: request_token_path,
        authorize_url: authorize_url,
        access_token_path: callback_url
      )
    end

    def get_request_token
      @request_token = @consumer.get_request_token(
        { oauth_callback: @callback_url },
        { scope: @scopes }
      )
    end
  end
end
