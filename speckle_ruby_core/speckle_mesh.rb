require_relative 'speckle_object'

class SpeckleMesh < SpeckleObject
  attr_accessor :vertices # [],
  attr_accessor :faces # [],
  attr_accessor :colors # [],
  attr_accessor :textureCoordinates # []

  def initialize
    super
    @type = 'Mesh'
    @vertices = []
    @faces = []
    @colors = []
    @textureCoordinates = []

    @points_list = []
    @points_hash = {} # use a hash to quickly access a point's index without iterating the full array
  end

  def pt_to_key(pt)
    "#{pt.x}_#{pt.y}_#{pt.z}"
  end

  def add_pt(pt)
    key = pt_to_key(pt)
    unless @points_hash.has_key?(key)
      @points_list.push(pt)
      @points_hash[key] = @points_list.length - 1
    end
    @points_hash[key]
  end

  def add_triangle(pt1, pt2, pt3)
    @faces.push(0) # a zero represents that the next 3 indices are triangle vertices
    @faces.push(add_pt(pt1))
    @faces.push(add_pt(pt2))
    @faces.push(add_pt(pt3))
  end

  def add_quad(pt1, pt2, pt3, pt4)
    @faces.push(1) # a one represents that the next 4 indices are quad vertices
    @faces.push(add_pt(pt1))
    @faces.push(add_pt(pt2))
    @faces.push(add_pt(pt3))
    @faces.push(add_pt(pt4))
  end

  def to_hash
    {
        :vertices => @vertices,
        :faces => @faces,
        :colors => @colors,
        :textureCoordinates => @textureCoordinates
    }.merge(super.to_hash)
  end
end