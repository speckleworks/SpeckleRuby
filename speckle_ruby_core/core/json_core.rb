class JsonCore
  def to_hash
    {}
  end

  def to_json(*args)
    to_hash.to_json
  end
end