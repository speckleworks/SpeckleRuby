require_relative 'response_base'

class ResponseObject < ResponseBase #https://speckleworks.github.io/SpeckleSpecs/?ruby#tocSresponseobject
  def initialize
    @success = true
    @message = ''
    @resources = []
  end

  def to_hash
    {
    }.merge(super.to_hash)
  end

  def to_json(*args)
    to_hash.to_json
  end
end