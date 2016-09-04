require 'rest-client'
require 'json'

module Scaleway
  class Client
    attr_accessor :access_key, :token

    def initialize(access_key, token)
      @host1 = 'https://api.scaleway.com'
      @host2 = 'https://account.scaleway.com'
      @access_key = access_key
      @token = token
      @instance = self
    end

    def self.instance
      #raise StandardError, 'Create client before accessing methods' if @instance.nil?
      #@instance
      Scaleway::Client.new(Chef::Config[:knife][:scaleway_access_key], Chef::Config[:knife][:scaleway_token])
    end

    def request(path, method, payload = nil)
      host = @host1 if path.index('/servers') || path.index('/images') || path.index('/volumes') || path.index('/ips')
      host = @host2 if path.index('/organizations')
      raise StandardError, "Add /#{path.split('/')[1]} to host map" if host.nil?

      headers = {:'X-Auth-Token' => @token, :'Content-Type' => 'application/json'}
      url = host + path

      options = { url: url, method: method, verify_ssl: false, headers: headers }
      if method == :post
        options.merge!(payload: payload)
        puts payload if ENV['DEBUG']
      end

      begin
        puts "### Req #{method.upcase} #{host + path}" if ENV['DEBUG']
        JSON.parse(RestClient::Request.execute(options).body, object_class: OpenStruct, array_class: Array)
      rescue => e
        data = JSON.parse(e.response, object_class: OpenStruct)
        puts "#{data.type}: #{data.message}"
      end
    end

    def get(path)
      request(path, :get)
    end

    def post(path, data)
      request(path, :post, data)
    end

    def put(path, data)
      request(path, :put, data)
    end
  end

  class Organization
    def self.all
      Client.instance.get('/organizations')
    end
  end

  class Ip
    def self.all
      Client.instance.get('/ips').ips
    end
  end

  class Image
    def self.all
      Client.instance.get('/images').images
    end

    def self.find(query)
      response = Client.instance.get('/images')
      response.images.select do |image|
        image.name.downcase.index(query.downcase)
      end
    end
  end

  class Server
    def self.all
      Client.instance.get('/servers').servers
    end

    def self.find(id)
      Client.instance.get("/servers/#{id}").server
    end

    def self.create(name, image, commercial_type)
      Client.instance.post('/servers', { name: name, organization: Client.instance.access_key, image: image, commercial_type: commercial_type}.to_json).server
    end

    def self.actions(id)
      Client.instance.get("/servers/#{id}/action")
    end

    def self.action(id, act)
      Client.instance.post("/servers/#{id}/action", { action: act }.to_json)
    end
  end

  class Volume
    def self.all
      Client.instance.get('/volumes').volumes
    end
  end
end
