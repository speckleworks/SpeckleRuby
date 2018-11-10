require_relative '../../speckle_ruby_core/core/json_core'

class LayerSelection < JsonCore
  attr_accessor :layerName # string layerName;
  attr_accessor :color # string color;
  attr_accessor :objectGuids # List<string> objectGuids;
  attr_accessor :objectTypes # List<string> objectTypes;

  def initialize(layerName, color)
    @layerName = layerName
    @color = color
    @objectGuids = []
    @objectTypes = []
  end

  def add_object(guid, type)
    @objectGuids.push(guid)
    @objectTypes.push(type)
  end

  def objectCount
    @objectGuids.length
  end

  def to_hash
    {
        :layerName => @layerName,
        :objectCount => objectCount,
        :color => @color,
        :objectGuids => @objectGuids,
        :objectTypes => @objectTypes,
    }.merge(super.to_hash)
  end
end