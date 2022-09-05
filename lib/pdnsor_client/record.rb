# frozen_string_literal: true

class PdnsorClient
  class Record
    attr_accessor :zone, :data, :_new_record

    delegate :client, to: :zone

    def initialize(data = {}, zone = nil, new_record = true)
      unless data.is_a? Hash
        zone = data
        data = {}
      end
      self.zone = zone
      self.data = HashWithIndifferentAccess.new(data)
      self._new_record = new_record
    end

    def new_record?
      _new_record
    end

    def save!
      if new_record?
        self.data = client.parse_response(
          client.request_record(:post, zone.data[:id], nil, record: data),
          :record
        )
        self._new_record = false
      else
        client.request_record :put, zone.data[:id], data[:id], record: data
      end
      self
    end

    def destroy!
      client.request_record :delete, zone.data[:id], data[:id]
    end
  end
end
