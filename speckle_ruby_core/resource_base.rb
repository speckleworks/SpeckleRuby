require 'securerandom'
require_relative 'core/json_core'
class ResourceBase < JsonCore
  attr_accessor :_id # "string",
  attr_accessor :owner # "string",
  attr_accessor :private # true,
  attr_accessor :anonymousComments # true,
  attr_accessor :canRead # [],
  attr_accessor :canWrite # [],
  attr_accessor :comments # [],
  attr_accessor :deleted # false

  def initialize
    @_id = SecureRandom.uuid
    @owner = SecureRandom.uuid
    @private = false
    @deleted = false
    @canRead = []
    @canWrite = []
    @comments = []
  end

  def to_hash
    {
        :_id => @_id,
        :owner => @owner,
        :private => @private,
        :deleted => @deleted,
        :canRead => @canRead,
        :canWrite => @canWrite,
        :comments => @comments,
    }
  end
end

