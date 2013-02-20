require 'uri'
require 'json'
require 'rest_client'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/to_query'

class PdnsorClient
  attr_accessor :config
  attr_reader :response

  class << self
    attr_accessor :config
  end
  self.config = {}


  def initialize(config = self.class.config)
    self.config = config
  end

  def build_zone(data)
    Zone.new data, self
  end

  def create_zone!(data)
    build_zone(data).save!
  end

  def request_zone(method, id = nil, data = {})
    result = request method, zone_url(id), data
  end

  def request_zone_by_name(method, id, data = {})
    request method, zone_by_name_url(id), data
  end

  def request_record(method, domain_id, id = nil, data = {})
    request method, record_url(domain_id, id), data
  end

  def find_zone(id)
    data = request_zone :get, id
    Zone.new data[:domain], self, false
  end

  def find_zone_by_name(name)
    data = request_zone_by_name :get, name
    Zone.new data[:domain], self, false
  end

  def request(method, path, data = {})
    domain, data = nil, domain if domain.is_a? Hash
    @response = RestClient.send method.to_s.downcase, path, data
    unless response.empty? # for :no_content
      result = JSON.parse response
      result.is_a?(Hash) ? HashWithIndifferentAccess.new(result) : result
    end
  rescue RestClient::Exception => e
    @response = e.http_body
    raise e
  end

  def parse_response(data, type)
    case type
    when :domain
      data[:domain]
    when :record
      {type: data.first[0]}.merge data.first[1]
    end
  end

  def url(path, query = {})
    URI::Generic::build(
      scheme:   config[:scheme] || 'https',
      userinfo: config[:userinfo],
      host:     config[:host],
      port:     config[:port],
      path:     "/api/v1#{path}",
      query:    { auth_token: config[:auth_token] }.merge(query).to_query
    ).to_s
  end

  def zone_url(domain_id = nil)
    url "/domains#{domain_id && '/' + domain_id.to_s}.json"
  end


  def zone_by_name_url(domain_name = nil)
    url "/domains/id.json", domain_name: domain_name
  end

  def record_url(domain_id, record_id = nil)
    url "/domains/#{domain_id}/records#{record_id && '/' + record_id.to_s}.json"
  end
end

require 'pdnsor_client/zone'
require 'pdnsor_client/record'