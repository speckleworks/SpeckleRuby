class SpeckleView
  def show_web_dialog
    speckle_view_dialog = UI::HtmlDialog.new(
        {
            :dialog_title => "Speckle",
            :scrollable => true,
            :resizable => true,
            :width => 300,
            :height => 400,
            :min_width => 200,
            :min_height => 200,
            :style => UI::HtmlDialog::STYLE_DIALOG
        })

    speckle_view_dialog.add_action_callback('setName') {|dialog, params|
      # puts "setName CALLED with params : #{dialog} #{params}"
      args = JSON.parse(params)
      puts "setName CALLED #{args['clientId']} #{args['name']}"
    }

    html_path = "#{File.dirname(__FILE__)}/dialog/index.html"
    speckle_view_dialog.set_file(html_path)
    speckle_view_dialog.show
  end
end

SpeckleView.new.show_web_dialog