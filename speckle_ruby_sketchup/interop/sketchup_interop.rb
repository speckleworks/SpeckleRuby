require_relative '../../speckle_ruby_core/extra/speckle_account'
require_relative '../../speckle_ruby_core/extra/layer_selection'
require_relative '../sketchup_utils'
require_relative 'speckle_selection_watcher'

class SketchupInterop

  def initialize(speckle_view)
    @speckle_view = speckle_view

    Sketchup.active_model.selection.add_observer(SpeckleSelectionWatcher.new(@speckle_view))
  end

  def speckle_settings_dir
    ENV['LOCALAPPDATA'] + '\SpeckleSettings'
  end

  def get_layers_and_objects_info
    model = Sketchup.active_model
    ss = model.selection

    ans = []

    if ss.empty?
      return ans
    end

    layers_by_id = {}

    ss.each {|e|
      if e.kind_of? Sketchup::Group
        unless layers_by_id.has_key?(e.layer.name)
          layer_selection = LayerSelection.new(e.layer.name, SketchupUtils.color_to_hex(e.layer.color))
          ans.push(layer_selection)
          layers_by_id[e.layer.name] = layer_selection
        end
        layers_by_id[e.layer.name].add_object(e.entityID, 'Mesh') #TODO figure out type
      end
    }
    ans
  end

  def read_user_accounts
    @user_accounts = []
    puts "read_user_accounts #{speckle_settings_dir}"
    Dir.foreach(speckle_settings_dir) do |fname|
      full_name = speckle_settings_dir + '\\' + fname
      puts "fname #{fname} #{File.extname(fname)} #{File.exists?(full_name)}"
      next unless File.exists?(full_name) and File.extname(fname) == '.txt'
      text = File.read(full_name).chomp!
      pieces = text.split(',')
      speckle_account = SpeckleAccount.new({email: pieces[0],
                                            apiToken: pieces[1],
                                            serverName: pieces[2],
                                            restApi: pieces[3],
                                            rootUrl: pieces[4],
                                            fileName: fname})
      @user_accounts.push(speckle_account)
    end
    @user_accounts
  end

  def user_accounts
    @user_accounts
  end

end

# SketchupInterop.new.read_user_accounts