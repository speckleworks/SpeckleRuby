class Layer < JsonCore
  attr_accessor :name # "string",
  attr_accessor :guid # "string",
  attr_accessor :orderIndex # 0, Describes this layer's position in the list of layers.
  attr_accessor :startIndex # 0, The index of the first object relative to the stream's objects array
  attr_accessor :objectCount # 0, How many objects does this layer have.
  attr_accessor :topology # "string",
  attr_accessor :properties # {}

  def initialize(name, color)
    super
    @name = name
    @guid = guid
    @orderIndex = 0
    @startIndex = 0
    @objectCount = 0
    @topology = ''
    @properties = LayerProperties.new(color)
  end

  def add_object(index)
    #TODO the startIndex refers to a position in the stream... so we should maintain that there
    if @objectCount == 0
      @startIndex = index
    end
    @objectCount += 1
  end

  def to_hash
    {
        :name => @name,
        :guid => @guid,
        :orderIndex => @orderIndex,
        :startIndex => @startIndex,
        :objectCount => @objectCount,
        :topology => @topology,
        :properties => @properties,
    }.merge(super.to_hash)
  end
end