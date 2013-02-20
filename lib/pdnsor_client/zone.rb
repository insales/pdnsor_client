class PdnsorClient
  class Zone
    attr_accessor :client, :data, :_new_record

    def initialize(data = {}, client = nil, new_record = true)
      client, data = data, {} unless data.is_a? Hash
      self.client = client
      self.data   = HashWithIndifferentAccess.new(data)
      self._new_record = new_record
    end

    def new_record?
      _new_record
    end

    def save!
      if new_record?
        self.data = client.parse_response(
          client.request_zone(:post, nil, domain: data), :domain)
        self._new_record = false
      else
        client.request_zone :put, data[:id], domain: data
      end
      self
    end

    def destroy!
      client.request_zone :delete, data[:id]
    end

    def destroy_records!
      client.request_record :delete, data[:id]
      @records = nil
    end

    def records(refresh = false)
      load_records if !@records || refresh
      @records
    end

    def load_records
      @records = []
      records_data = client.request_record(:get, data[:id])
      records_data.each do |data|
        @records << Record.new(client.parse_response(data, :record), self, false)
      end
    end

    def build_record(data)
      Record.new data, self
    end

    def create_record!(data)
      build_record(data).save!
    end
  end
end