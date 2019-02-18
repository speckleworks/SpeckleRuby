require_relative 'speckle_object'

class SpecklePlaceholder < SpeckleObject
  def initialize(id)
    super
    @_id = id
    @type = 'Placeholder'
  end

  def to_hash
    {
    }.merge(super.to_hash)
  end


end