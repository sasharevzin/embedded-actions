require File.expand_path(File.dirname(__FILE__) + "/rails/test/test_helper")

# Add 'lib' to ruby's library path and load the plugin libraries (code copied from Rails railties initializer's load_plugin)
#lib_path  = File.expand_path(File.dirname(__FILE__) + "/../lib")
#application_lib_index = $LOAD_PATH.index(File.join(RAILS_ROOT, "lib")) || 0  
#$LOAD_PATH.insert(application_lib_index + 1, lib_path)
#require File.expand_path(File.dirname(__FILE__) + "/../init")

class TestControllerWithDefaultEmbeddedOptions < TestController
  def default_embedded_options(options)
    {:id => 30}
  end
end

class DefaultEmbeddedOptionsTest < ActionController::TestCase
  def setup
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    FileUtils.rm_rf Rails.root.join "tmp/cache"
  end

  def test_normalize_embedded_options
    @controller = TestController.new
    @controller.default_url_options = {:id => 15, :category => "red"}
    assert_equal({:id => 1, :params => {'category' => "red"}}, @controller.normalize_embedded_options({:id => 1, :category => "red"}))
    assert_equal({:id => 1, :params => {'category' => "red"}}, @controller.normalize_embedded_options({:id => 1, :params => {:category => "red"}}))
    assert_equal({:params => {'category' => "blue"}}, @controller.normalize_embedded_options({:category => "blue"}))
    assert_equal({:params => {'category' => "blue"}}, @controller.normalize_embedded_options({:category => "red", :params => {:category => "blue"}}))
  end
  
  def test_default_url_options
    @controller = TestController.new
    @controller.default_url_options = {:id => 15}
    assert_equal({:id => 15}, @controller.rewrite_embedded_options({}))
    assert_equal({:id => 16}, @controller.rewrite_embedded_options({:id => 16}))
  end

  def test_default_url_options_with_implicit_params
    @controller = TestController.new
    @controller.default_url_options = {:id => 15, :category => "red"}

    assert_equal({:id => 15, :params => {'category' => "red"}}, @controller.rewrite_embedded_options({}))
    assert_equal({:id => 16, :params => {'category' => "red"}}, @controller.rewrite_embedded_options({:id => 16}))
    assert_equal({:id => 15, :params => {'category' => "blue"}}, @controller.rewrite_embedded_options({:category => "blue"}))
  end

  def test_default_embedded_options
    @controller = TestControllerWithDefaultEmbeddedOptions.new
    @controller.default_url_options = {:id => 15}
    assert_equal({:id => 30}, @controller.rewrite_embedded_options({}))
  end
  
  def test_embed_action_with_default_options
    @controller = TestController.new
    @controller.default_url_options = {:id => 15, :category => "red"}

    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params' %>"
    assert_equal "Params: action: dump_params, category: red, controller: test, id: 15", @response.body, "embed_action should use default options"

    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 16 %>"
    assert_equal "Params: action: dump_params, category: red, controller: test, id: 16", @response.body, "embed_action should use default options"

    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 16, :category => 'blue' %>"
    assert_equal "Params: action: dump_params, category: blue, controller: test, id: 16", @response.body, "embed_action should use default options"

    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 16, :params => {:category => 'blue'} %>"
    assert_equal "Params: action: dump_params, category: blue, controller: test, id: 16", @response.body, "embed_action should use default options"
  end
  
end
