module EngageDatagen
  class RavenClient
    def initialize url, opts={}
      @url = url
      @user = opts[:user]
      @password = opts[:password]
      @database_name = opts[:database_name]

      @site = resource_class.new database_url, @user, @password
    end

    def store dataset
      dataset.each do |doc|
        headers = {
            content_type: :json
        }.merge(doc.metadata)

        @site[document_url(doc.id)].put doc.data.to_json, headers
      end
    end

    private
      def resource_class
        RestClient::Resource
      end

      def document_url id
        "docs/#{id}"
      end

      def database_url
        if @database_name
          "#{server_url}/databases/#{@database_name}"
        else
          "#{server_url}"
        end
      end

      def server_url
        @url.chomp('/')
      end
  end
end

class Time
  def as_json
    strftime '%Y-%m-%dT%H:%M:%S.0000000'
  end
end