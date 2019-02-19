# load 'C:\Users\kgoulding\Documents\Development\Ruby\SpeckleRuby\speckle_ruby_sketchup_direct\ui\speckle_view.rb'
require_relative '../interop/sketchup_interop'
require_relative '../speckler'
class SpeckleView
  def initialize
    @interop = SketchupInterop.new(self)
    @speckler = Speckler.new
  end

  def show_web_dialog
    speckle_view_dialog = UI::HtmlDialog.new(
        {
            :dialog_title => "Speckle",
            :scrollable => true,
            :resizable => true,
            :width => 700,
            :height => 550,
            :min_width => 200,
            :min_height => 200,
            :style => UI::HtmlDialog::STYLE_DIALOG
        })
    @dialog = speckle_view_dialog

    #can be used to debug against source when using React dev server
    speckle_view_dialog.set_url('http://localhost:3000/')

    # html_path = "#{File.dirname(__FILE__)}/dialog/index.html"
    # speckle_view_dialog.set_file(html_path)

    speckle_view_dialog.add_action_callback('getSelectedMesh') {|dialog, params|
      # puts "setName CALLED with params : #{dialog} #{params}"
      # args = JSON.parse(params)
      send_response_to_view(get_current_selection, 'mesh')
    }

    speckle_view_dialog.add_action_callback('getSelectedPaths') {|dialog, params|
      # puts "setName CALLED with params : #{dialog} #{params}"
      # args = JSON.parse(params)
      send_response_to_view(get_current_selection, 'paths')
    }

    speckle_view_dialog.show
  end

  def get_current_selection
    model = Sketchup.active_model
    ss = model.selection

    if ss.empty?
      UI.messagebox('Please select something')
      return
    end
    @speckler.create_speckle_objects(ss)
  end

  def send_response_to_view(response, command)
    js_command = "Interop.UpdateObjects(#{JSON.generate(response)}, '#{command}');"
    @dialog.execute_script(js_command)
  end

  def on_selection_change
    # js_command = "Interop.NotifySpeckleFrame( 'object-selection', '', #{JSON.generate(@interop.get_layers_and_objects_info)} );"
    # @dialog.execute_script(js_command)
  end
end

SpeckleView.new.show_web_dialog