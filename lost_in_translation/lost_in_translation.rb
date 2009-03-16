class LostInTranslation
  # Expresión regular para recoger todas las cadenas de traducción de la aplicación
  MATCH = /\b(?:I18n\.t|I18n\.translate|t)(?:\s|\():?'([a-z0-9_]+.[a-z0-9_.]+)'\)?/
  
  def initialize
    @locale = 'en'
    @file = "#{@locale}.yml"
    @translations = []
    @hash = {}
  end


  # Definimos el nombre del fichero de traducciones con el queremos trabajar,
  # si no es especifica coje el yaml del mismo nombre de la loca definida
  def yaml=(file)
    @file = file
  end
  
  # Devuelve el nombre del fichero donde se salvarán las traducciones
  def yaml
    @file
  end
  
  # Definimo el idioma al que queremos añadir las traducciones perdidas
  def locale=(locale)
    @locale = I18n.locale = locale
  end
  
  # Devuelve el nombre de la locale con la que trabajaremos
  def locale
    @locale
  end
  
  
  # Escaneamos la carpeta app en busca de todas las cadenas 
  def scan_app
    @translations = []
    Pathname.new('app/').find do |path|
      if can_open?(path)
        read_file(path)
      end
    end
    @translations.flatten
  end
  
  
  # Almacena en memoria usando la api i18n de Rails todas las traducciones,
  # y lo devuelve como un hash
  def store_translations
    keys = exists_keys
    extract_i18n_keys(I18n.backend.send(:translations)[@locale.to_sym]).sort
    scan_app if @translations.blank?
    @translations.each do |translation|
      translation =  to_deep_hash({translation.to_s => nil})
      I18n.backend.store_translations(@locale.to_sym, translation)
    end
    # Stringifying keys for prettier YAML
    @hash = deep_stringify_keys({
      @locale => I18n.backend.send(:translations)[@locale.to_sym]
    })
  end
  
  # Guarda en el .yml las nuevas traducciones encontradas
  def save_translations
    store_translations if @hash.blank?
    File.open("config/locales/#{@file}", "w") do |file|
      file.puts @hash.to_yaml
    end
  end

  
  # Mostramos las traducciones existentes en el archivo de traducción configurado
  # FIXME: Si el archivo .yml no tiene almenos una traducción falla
  def exists_keys
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    extract_i18n_keys(I18n.backend.send(:translations)[@locale.to_sym]).sort
  end
  
  
  private
  
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

