class StringToHash

  attr_reader :hash
  
  def initialize
    @hash = {}   
  end
  
  def add(key, value = nil)
    key_value = to_deep_hash({key => value})
    translation = deep_symbolize_keys(key_value)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    @hash.merge!(translation, &merger)
  end
  
  def add_prefix(prefix)
    prefix.split('.').reverse.each do |split|
      @hash = deep_stringify_keys({split  => @hash})
    end
  end
  

  private
  def deep_stringify_keys(hash)
    hash.inject({}) { |result, (key, value)|
      value = deep_stringify_keys(value) if value.is_a? Hash
      result[(key.to_s rescue key) || key] = value
      result
    }
  end
  
  def deep_symbolize_keys(hash)
    hash.inject({}) { |result, (key, value)|
      value = deep_symbolize_keys(value) if value.is_a? Hash
      result[(key.to_sym rescue key) || key] = value
      result
    }
  end
  
  def to_deep_hash(hash)    
    hash.inject({}) do |deep_hash, (key, value)|
      keys = key.split('.').reverse
      leaf_key = keys.shift
      key_hash = keys.inject({leaf_key.to_sym => value}) { |hash, key| {key.to_sym => hash} }
      deep_merge!(deep_hash, key_hash)
      deep_hash
    end
  end
  
  def deep_merge!(hash1, hash2)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    hash1.merge!(hash2, &merger)
  end
  
end


