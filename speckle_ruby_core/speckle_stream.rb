class SpeckleStream < ResourceBase
  attr_accessor :streamId # "string",
  attr_accessor :name # "string",
  attr_accessor :objects # [],
  attr_accessor :layers # [],
  attr_accessor :baseProperties # {},
  attr_accessor :globalMeasures # {},
  attr_accessor :isComputedResult # false,
  attr_accessor :viewerLayers # [],
  attr_accessor :parent # "string",
  attr_accessor :children # [],
  attr_accessor :ancestors # []

  def initialize(stream_id)
    super
    @streamId = stream_id
    @objects = []
    @layers = []
    @layers_by_name = {}
  end

  def add_object(object, layer_name, layer_color)
    unless @layers_by_name.has_key?(layer_name)
      #TODO refer to SpeckleRhinoPlugin/src/SpeckleRhinoSender.cs:283
      @layers_by_name[layer_name] = Layer.new(layer_name, layer_color)
      @layers.push(@layers_by_name[layer_name])
    end
    #TODO objects should be sorted to ensure order is maintained within stream objects and Layer.startIndex
    @layers_by_name[layer_name].add_object(@objects.length)
    @objects.push(object)
  end

  def to_hash
    {
        :streamId => @streamId,
        :name => @name,
        :objects => @objects,
        :layers => @layers,
        :baseProperties => @baseProperties,
        :globalMeasures => @globalMeasures,
        :isComputedResult => @isComputedResult,
        :viewerLayers => @viewerLayers,
        :parent => @parent,
        :children => @children,
        :ancestors => @ancestors,
    }.merge(super.to_hash)
  end
end