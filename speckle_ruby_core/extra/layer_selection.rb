require_relative '../../speckle_ruby_core/core/json_core'

class LayerSelection < JsonCore
  attr_accessor :layerName # string layerName;
  attr_accessor :color # string color;
  attr_accessor :ObjectGuids # List<string> ObjectGuids;
  attr_accessor :ObjectTypes # List<string> ObjectTypes;

  def initialize(layerName, color)
    @layerName = layerName
    @color = color
    @ObjectGuids = []
    @ObjectTypes = []
  end

  def add_object(guid, type)
    @ObjectGuids.push(guid)
    @ObjectTypes.push(type)
  end

  def objectCount
    @ObjectGuids.length
  end

  def to_hash
    {
        :layerName => @layerName,
        :objectCount => objectCount,
        :color => @color,
        :ObjectGuids => @ObjectGuids,
        :ObjectTypes => @ObjectTypes,
    }.merge(super.to_hash)
  end
end