class LostInTranslation
  # Expresión regular para recoger todas las cadenas de traducción de la aplicación
  MATCH = /\b(?:I18n\.t|I18n\.translate|t)(?:\s|\():?'([a-z0-9_]+.[a-z0-9_.]+)'\)?/

  attr_accessor :file, :locale, :path
  
  def initialize
    @locale = 'en'
    @file = "config/locales/#{@locale}.yml"
    @translations = []
    @hash = {}
    @path = 'app/'
  end

  # Escaneamos la carpeta en busca de todas las cadenas coincidentes con la expresión regular
  def scan
    @translations = []
    Pathname.new(@path).find do |path|
      if can_open?(path)
        read_file(path)
      end
    end
    @translations.flatten!
  end
  
  def store
    scan if @translations.empty?
    @translations.each do |translation|
      key_value = to_deep_hash({translation => nil})
      translation = deep_symbolize_keys(key_value)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      @hash.merge!(translation, &merger)
    end
    @hash = deep_stringify_keys({@locale  => @hash})
  end
  
  # Guarda en el .yml las nuevas traducciones encontradas
  def save
    store if @hash.empty?
    File.open(@file, "w") do |file|
      file.puts @hash.to_yaml
    end
  end

  
  private
  
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
  
  def deep_stringify_keys(hash)
    hash.inject({}) { |result, (key, value)|
      value = deep_stringify_keys(value) if value.is_a? Hash
      result[(key.to_s rescue key) || key] = value
      result
    }
  end
  
  # Convertimos el hash que le pasemos a un array
  # NOTA: Este método está sacado del plugin translate
  # http://github.com/newsdesk/translate
  def extract_i18n_keys(hash, parent_keys = [])
    hash.inject([]) do |keys, (key, value)|
      full_key = parent_keys + [key]
      if value.is_a?(Hash)
        # Nested hash
        keys += extract_i18n_keys(value, full_key)
      elsif value.present?
        # String leaf node
        keys << full_key.join(".")
      end
      keys
    end
  end
  
  # Comprueba si es un fichero y si puedo leerlo
  def can_open?(path)
    !path.directory? && !path.zero? && path.readable?
  end
  
  # Leemos el fichero de donde sacaremos las traducciones del tipo t()
  def read_file(file)
    file.readlines.each do |line|
      scan_line(line)
    end
  end
  
  # Escaneamos la linea busqueda de cadenas del tipo t()
  # y añadimos las coincidencias a @translations
  def scan_line(line)
    line.scan(MATCH) do |match|
      @translations << match
    end
  end
  
end

