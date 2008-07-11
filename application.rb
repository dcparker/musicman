require 'lib/catalog'

class MusicMan < Merb::Controller
  def _template_location(action, type=nil, controller=controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

  def index
    "Music Man!<br />#{Catalog.count} Songs"
  end
end
