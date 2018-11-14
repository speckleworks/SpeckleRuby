require_relative '../../speckle_ruby_core/extra/speckle_account'
require_relative '../../speckle_ruby_core/extra/layer_selection'
require_relative '../../speckle_ruby_core/extra/speckle_interop'
require_relative '../sketchup_utils'
require_relative 'speckle_selection_watcher'

class SketchupInterop < SpeckleInterop

  def initialize(speckle_view)
    @speckle_view = speckle_view

    Sketchup.active_model.selection.add_observer(SpeckleSelectionWatcher.new(@speckle_view))
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

end

# SketchupInterop.new.read_user_accounts