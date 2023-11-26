# frozen_string_literal: true

require_relative 'usos_auth/version'
require 'oauth'

module UsosAuth
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :consumer_key, :consumer_secret, :site, :request_token_path,
                  :authorize_path, :access_token_path, :callback_url, :scopes, :fields

    def initialize
      @consumer_key = ''
      @consumer_secret = ''
      @site = ''
      @request_token_path = ''
      @authorize_path = ''
      @access_token_path = ''
      @callback_url = ''
      @scopes = ''
      @fields = ''
    end
  end

  class Authenticator
    def authenticate
      load_config
      request_token
      store_tokens(@consumer, @request_token, @site)
      yield(authorize_url)
    end

    def callback(verifier)
      load_stored_tokens
      clear_stored_tokens
      access_token = @request_token.get_access_token(oauth_verifier: verifier)

      response = access_token.get('/services/users/user')

      JSON.parse(response.body)
    end

    private

    def load_config
      configuration = UsosAuth.configuration
      consumer_key = configuration.consumer_key
      consumer_secret = configuration.consumer_secret
      request_token_path = configuration.request_token_path
      authorize_path = configuration.authorize_path
      @site = configuration.site
      @access_token_path = configuration.access_token_path
      @callback_url = configuration.callback_url
      @scopes = configuration.scopes
      @fields = configuration.fields

      @consumer = OAuth::Consumer.new(
        consumer_key,
        consumer_secret,
        site: @site,
        request_token_path: request_token_path,
        authorize_path: authorize_path,
        access_token_path: @access_token_path
      )
    end

    def request_token
      @request_token = @consumer.get_request_token(
        { oauth_callback: @callback_url },
        { scope: @scopes }
      )
    end

    def authorize_url
      @request_token.authorize_url
    end

    def store_tokens(consumer, request_token, site)
      $stored_tokens ||= {}
      $stored_tokens[:consumer] = consumer
      $stored_tokens[:request_token] = request_token
      $stored_tokens[:site] = site
    end

    def load_stored_tokens
      @consumer = $stored_tokens[:consumer]
      @request_token = $stored_tokens[:request_token]
      @site = $stored_tokens[:site]
    end

    def clear_stored_tokens
      $stored_tokens[:consumer] = nil
      $stored_tokens[:request_token] = nil
      $stored_tokens[:site] = nil
    end
  end
end
