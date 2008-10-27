# NOTE: shouldn't the view templates be loaded from the slice first, app second, and gem last?

Merb::Authentication.customize_default do
  Exceptions.class_eval do
    # # This stuff allows us to provide a default view
    the_view_path = File.expand_path(File.dirname(__FILE__) / '..' / 'views')
    self._template_roots ||= []
    self._template_roots << [the_view_path, :_template_location]
    self._template_roots << [Merb.dir_for(:view), :_template_location]
  end
end
