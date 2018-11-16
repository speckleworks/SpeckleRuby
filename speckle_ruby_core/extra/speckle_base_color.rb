class SpeckleBaseColor < JsonCore
  attr_accessor :a # "float" alpha value
  attr_accessor :hex # "string" hex color value

  def initialize(hex)
    super
    @a = 1
    @hex = hex
  end

  def to_hash
    {
        :a => @a,
        :hex => @hex,
    }.merge(super.to_hash)
  end
end