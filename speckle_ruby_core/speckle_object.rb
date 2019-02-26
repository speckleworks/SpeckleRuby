require 'securerandom'
require_relative 'resource_base'

class SpeckleObject < ResourceBase
  attr_accessor :type # "Null",
  attr_accessor :hash # "hash",
  attr_accessor :geometryHash # "Type.hash",
  attr_accessor :applicationId # "GUID" this represents the internal object ID in the host application (e.g. Rhino) it is NOT the same across all clients.
  attr_accessor :properties # {},
  attr_accessor :parent # "string",
  attr_accessor :name # "string",
  attr_accessor :children # [],
  attr_accessor :ancestors # [],
  attr_accessor :transform # []

  def initialize
    super
    @hash = SecureRandom.uuid
    @applicationId = nil
    @parent = ''
    @name = ''
    @properties = {}
    @children = []
    @ancestors = []
    @transform = []
  end

  def update_id(id)
    @_id = id
    placeholder = SpecklePlaceholder.new(id)
    placeholder.applicationId = @applicationId
    placeholder
  end

  def to_hash
    {
        :type => @type,
        :hash => @hash,
        :geometryHash => geometryHash,
        :applicationId => @applicationId,
        :properties => @properties,
        :parent => @parent,
        :name => @name,
        :children => @children,
        :ancestors => @ancestors,
        :transform => @transform
    }.merge(super.to_hash)
  end

  def geometryHash
    "#{@type}.#{@hash}"
  end
end