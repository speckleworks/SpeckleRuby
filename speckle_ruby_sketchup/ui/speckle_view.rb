require_relative '../interop/sketchup_interop'
class SpeckleView
  def initialize
    @interop = SketchupInterop.new(self)
  end

  def show_web_dialog
    speckle_view_dialog = UI::HtmlDialog.new(
        {
            :dialog_title => "Speckle",
            :scrollable => true,
            :resizable => true,
            :width => 300,
            :height => 450,
            :min_width => 200,
            :min_height => 200,
            :style => UI::HtmlDialog::STYLE_DIALOG
        })
    @dialog = speckle_view_dialog

    speckle_view_dialog.add_action_callback('setName') {|dialog, params|
      # puts "setName CALLED with params : #{dialog} #{params}"
      args = JSON.parse(params)
      puts "setName CALLED #{args['clientId']} #{args['name']}"
    }

    speckle_view_dialog.add_action_callback('logCall') {|dialog, params|
      # puts "setName CALLED with params : #{dialog} #{params}"
      args = JSON.parse(params)
      puts "CALLED #{params}"
    }

    speckle_view_dialog.add_action_callback('getUserAccounts') {|dialog, params|
      # puts "setName CALLED with params : #{dialog} #{params}"
      # args = JSON.parse(params)
      puts "CALLED getUserAccounts #{params}"

      user_accounts = @interop.read_user_accounts
      js_command = "Interop.UserAccounts = "+JSON.generate(user_accounts)
      # puts "js_command: #{js_command}"
      speckle_view_dialog.execute_script(js_command)
      #Note we set the Interop.UserAccounts property here so it is available in the callback (there is no way to directly return the value)
    }

    speckle_view_dialog.add_action_callback('getLayersAndObjectsInfo') {|dialog, params|
      layers_and_objects_info = @interop.get_layers_and_objects_info
      js_command = "Interop._returnValues.getLayersAndObjectsInfo = "+JSON.generate(layers_and_objects_info)
      puts "js_command: #{js_command}"
      speckle_view_dialog.execute_script(js_command)
    }

    speckle_view_dialog.add_action_callback('appReady') {|dialog, params|
      # user_accounts = @interop.read_user_accounts
      #
      # js_command = "Interop.UserAccounts = "+JSON.generate(@interop.read_user_accounts)
      # speckle_view_dialog.execute_script(js_command)

      on_selection_change
    }

    #can be used to debug against source when using dev server for SpeckleView
    speckle_view_dialog.set_url('http://127.0.0.1:9090/')

    # html_path = "#{File.dirname(__FILE__)}/dialog/index.html"
    # speckle_view_dialog.set_file(html_path)

    speckle_view_dialog.show
  end

  def on_selection_change
    js_command = "Interop.NotifySpeckleFrame( 'object-selection', '', #{JSON.generate(@interop.get_layers_and_objects_info)} );"
    @dialog.execute_script(js_command)
  end
end

SpeckleView.new.show_web_dialog