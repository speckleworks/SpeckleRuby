class LayerProperties < JsonCore
  attr_accessor :color #{},
  attr_accessor :visible #true,
  attr_accessor :pointsize #0,
  attr_accessor :linewidth #0,
  attr_accessor :shininess #0,
  attr_accessor :smooth #true,
  attr_accessor :showEdges #true,
  attr_accessor :wireframe #true

  def initialize(hex)
    super
    @color = SpeckleBaseColor.new(hex)
    @visible = true
    @pointsize = 0
    @linewidth = 0
    @shininess = 0
    @smooth = true
    @showEdges = true
    @wireframe = true
  end


  def to_hash
    {
        :color => @color,
        :visible => @visible,
        :pointsize => @pointsize,
        :linewidth => @linewidth,
        :shininess => @shininess,
        :smooth => @smooth,
        :showEdges => @showEdges,
        :wireframe => @wireframe,
    }.merge(super.to_hash)
  end
end