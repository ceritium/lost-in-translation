# Para que la tarea rake funcione tanto este archivo como la carpeta
# lost_in_translation deben estar situados en lib/tasks

require File.expand_path(File.dirname(__FILE__)) + '/lost_in_translation/lost_in_translation'

namespace :i18n do
  desc 'Tarea que busca y añade todas las cadenas del tipo t() al archivo de traducción es.yml'
  task(:lost_in_translation => :environment) do
    i18n = LostInTranslation.new
    i18n.save
  end
end