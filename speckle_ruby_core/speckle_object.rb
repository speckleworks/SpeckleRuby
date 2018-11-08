require 'securerandom'
require_relative 'resource_base'

class SpeckleObject < ResourceBase
  attr_accessor :type # "Null",
  attr_accessor :hash # "hash",
  attr_accessor :geometryHash # "Type.hash",
  attr_accessor :applicationId # "GUID",
  attr_accessor :properties # {},
  attr_accessor :parent # "string",
  attr_accessor :children # [],
  attr_accessor :ancestors # [],
  attr_accessor :transform # []

  def initialize
    super
    @hash = SecureRandom.uuid
    @applicationId = SecureRandom.uuid
    @parent = ''
    @properties = {}
    @children = []
    @ancestors = []
    @transform = []
  end

  def to_hash
    {
        :type => @type,
        :hash => @hash,
        :geometryHash => geometryHash,
        :applicationId => @applicationId,
        :properties => @properties,
        :parent => @parent,
        :children => @children,
        :ancestors => @ancestors,
        :transform => @transform
    }.merge(super.to_hash)
  end

  def geometryHash
    "#{@type}.#{@hash}"
  end

  def to_json(*args)
    to_hash.to_json
  end
end