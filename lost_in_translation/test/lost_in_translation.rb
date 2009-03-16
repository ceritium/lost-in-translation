BASE_PATH = File.expand_path(File.dirname(__FILE__))
require File.join(BASE_PATH,'/../lost_in_translation')
require 'test/unit'

class LostInTranslationTest < Test::Unit::TestCase
  
  def setup
    @lit = LostInTranslation.new
  end
  
  def test_set_yaml
    @lit.yaml = 'test.yml'
    assert_equal 'test.yml', @lit.yaml
  end
  
  def test_set_locale
    #@lit.locale = 'es'
    #assert_equal 'es', @lit.locale
  end

end