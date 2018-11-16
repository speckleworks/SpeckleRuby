require 'json'
require 'net/http'
class SpeckleApiClient
  # region init
  def initialize(baseUrl)
    @baseUrl = baseUrl
  end

  def get_uri(path)
    URI("#{@baseUrl}#{path}")
  end

  def initialize_sender(authToken, documentName, documentType, documentGuid)
    @authToken = authToken
  end

  # endregion

  # region core
  def use_ssl
    @baseUrl.index('https://') == 0
  end

  def populate_req(req, body)
    req['Content-Type'] = 'application/json'
    req['Accept'] = 'application/json'
    req['Authorization'] = @authToken
    req.body = body
    req
  end

  def post(path, body)
    uri = get_uri(path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
      http.request(populate_req(Net::HTTP::Post.new(uri), body))
    end
  end

  def put(path, body)
    uri = get_uri(path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
      http.request(populate_req(Net::HTTP::Put.new(uri), body))
    end
  end

  def get(path)
    uri = get_uri(path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
      req = Net::HTTP::Get.new(uri)
      req['Accept'] = 'application/json'
      req['Authorization'] = @authToken
      http.request(req)
    end

  end

  def delete(path)
    uri = get_uri(path)
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
      req = Net::HTTP::Delete.new(uri)
      req['Accept'] = 'application/json'
      req['Authorization'] = @authToken
      http.request(req)
    end
  end

  # endregion

  # region /streams/
  def stream_create(streams)
    post('/streams', JSON.generate(streams))
  end

  def stream_update(stream)
    put("/streams/#{stream._id}", stream.to_json)
  end

  def stream_get(stream_id)
    get("/streams/#{stream_id}")
  end

  def stream_delete(stream_id)
    delete("/streams/#{stream_id}")
  end

  # endregion

  # region /objects/
  def object_create(objects)
    post('/objects', JSON.generate(objects))
  end

  def object_update(object)
    put("/objects/#{object._id}", object.to_json)
  end

  def object_get(object_id)
    get("/objects/#{object_id}")
  end

  def object_delete(object_id)
    delete("/objects/#{object_id}")
  end
  # endregion
end