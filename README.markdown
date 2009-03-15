Lost In Translation
==========

LostInTranslation es una pequeña clase que nos puede ayudar a mantener al día las traducciones en nuestras aplicaciones que tiren la API I18n de RAILS y que tengan como backend los ficheros yaml.

Uso
============

Su uso es muy sencillo, con solo dos comandos lineas ya puedes recorrer todo el directorio _app_ de tu aplicación y añadir los traducción que anden sueltas al fichero _en.yaml_.
  
    i18n = LostInTranslation.new
    i18n.save_translations

También tienes otros métodos disponibles para configurar el idioma e incluso el archivo de destino.

    i18n = LostInTranslation.new
    
    # Pone el español como el idioma de destino
    i18n.set_locale('es')
    
    # Por si por ejemplo queremos almacenar las traducciónes en otro archivo, en este case será prueba_es.yaml
    i18n.set_yaml('prueba_es')
    
    i18n.save_translations
    
TODO
===========
* Tests
* Añadir a varios idiomas a la vez
* Cuando el fichero del idioma está vacío falla.
* _Gemíficar_
* Traducir


Fedback
===========

Se agradece todo el feedback posible, desde errores, casos de uso o posibles mejoras.

* Blog: [http://ceritium.net/476/programacion/rails/lost-in-translation/](http://ceritium.net/476/programacion/rails/lost-in-translation/ 'Entrada en mi blog')
* Correo: ceritium@gmail.com
* **Fork Me!**

Agradecimientos
=============

Al plugin [Translate](http://github.com/newsdesk/translate/tree/master "Translate Plugin") del que pillo algunos métodos.