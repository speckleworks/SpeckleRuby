require_relative 'ui/speckle_view'
module SAS::ViewPoints

  unless $viewpoint_menu_loaded
    $viewpoint_menu_loaded = true

    plugins_menu = UI.menu('Plugins')
    cm_menu = plugins_menu.add_submenu('View Points')
    cm_menu.add_item('Show') {SpeckleView.new.show_web_dialog}
  end
end