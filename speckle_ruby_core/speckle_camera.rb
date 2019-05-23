require_relative 'speckle_object'

class SpeckleCamera < SpeckleObject
  attr_accessor :eye # [],
  attr_accessor :aspectRatio
  attr_accessor :target # [],
  attr_accessor :up # [],
  attr_accessor :fov# float
  attr_reader :type

  def initialize()
    super
    @type = 'Camera'
    @eye = [0,0,0]
    @target = [0,1,0]
    @up = [0,0,1]
    @fov = 90
    @aspectRatio = 1
  end

  def to_hash
    {
        :eye=> @eye,
        :target=> @target,
        :up=> @up,
        :fov=> @fov,
        :aspectRatio=> @aspectRatio,
    }.merge(super.to_hash)
  end
end