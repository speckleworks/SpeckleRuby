require_relative '../../speckle_ruby_core/core/json_core'

class SpeckleAccount < JsonCore
  attr_accessor :email
  attr_accessor :apiToken
  attr_accessor :serverName
  attr_accessor :restApi
  attr_accessor :rootUrl
  attr_accessor :fileName

  def initialize(hash = {})
    @email = hash[:email]
    @apiToken = hash[:apiToken]
    @serverName = hash[:serverName]
    @restApi = hash[:restApi]
    @rootUrl = hash[:rootUrl]
    @fileName = hash[:fileName]
  end

  def to_hash
    {
        :email => @email,
        :apiToken => @apiToken,
        :serverName => @serverName,
        :restApi => @restApi,
        :rootUrl => @rootUrl,
        :fileName => @fileName
    }.merge(super.to_hash)
  end

end