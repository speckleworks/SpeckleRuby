require_relative 'speckle_object'

class SpecklePolyline < SpeckleObject
  attr_accessor :closed # [],
  attr_accessor :value # [] Flat array of positions x1, y1, z1, x2, y2, z2, ...
  attr_accessor :domain # [],

  def initialize
    super
    @type = 'Polyline'
    @closed = true
    @value = []
    @domain = {}
  end

  def addPoint(v)
    @value.push(v.x)
    @value.push(v.y)
    @value.push(v.z)
  end

  def to_hash
    {
        :closed => @closed,
        :value => @value,
        :domain => @domain,
    }.merge(super.to_hash)
  end


end