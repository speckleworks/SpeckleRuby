class JsonCore
  def to_hash
    {}
  end

  def compact(hash) #https://stackoverflow.com/questions/3450641/removing-all-empty-elements-from-a-hash-yaml
    # removed clause "and v.compact.empty?)" as not supported by this ruby version
    hash.delete_if{|k, v|
      (v.is_a?(Hash) and v.respond_to?('empty?')) or
          (v.nil?)  or
          (v.is_a?(String) and v.empty?)
    }
  end

  def to_json(*args)
    #the API doesn't like empty values so pull them out using compact before serializing
    compact(to_hash).to_json
  end
end