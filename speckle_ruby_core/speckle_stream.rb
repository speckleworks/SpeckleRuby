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
    @placeholder_objects = [] # maintain the PlaceHolder object array for the stream
    @speckle_objects_by_id = {} # store a lookup of SpeckleObjects by their application id
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
    @placeholder_objects.push(object)
  end

  def connect_placeholders(speckle_objects, server_generated_ids)
    # any time a SpeckleObject is updated, it gets a new id from the server
    # the stream is expected to maintain a list of these ids as Placeholder objects (the @placeholder_objects array here)
    # internally, we use the applicationId as a way to keep track of objects in this stream
    speckle_objects.zip(server_generated_ids).each do |speckle_object, id|
      @placeholder_objects.push(speckle_object.update_id(id))
    end
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