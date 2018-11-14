require 'json'
require 'net/http'
class SpeckleApiClient

  def initialize(baseUrl)
    @baseUrl = baseUrl
  end

  def get_uri(path)
    URI("#{@baseUrl}#{path}")
  end

  def initialize_sender(authToken, documentName, documentType, documentGuid)
    @authToken = authToken
  end

  def post(path, body)
    uri = get_uri(path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: false) do |http|
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req['Accept'] = 'application/json'
      req['Authorization'] = @authToken
      # The body needs to be a JSON string, use whatever you know to parse Hash to JSON
      req.body = body
      http.request(req)
    end

  end

  def get(path)
    uri = get_uri(path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: false) do |http|
      req = Net::HTTP::Get.new(uri)
      req['Accept'] = 'application/json'
      req['Authorization'] = @authToken
      http.request(req)
    end

  end

  def delete(path)
    uri = get_uri(path)
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: false) do |http|
      req = Net::HTTP::Delete.new(uri)
      req['Accept'] = 'application/json'
      req['Authorization'] = @authToken
      http.request(req)
    end
  end

  def object_create(objects)
    post('/objects', JSON.generate(objects))
  end

  def object_update(object)
    post("/objects/#{object._id}", object.to_json)
  end

  def object_get(object_id)
    get("/objects/#{object_id}/")
  end

  def object_delete(object_id)
    delete("/objects/#{object_id}")
  end
end