class SpeckleSelectionWatcher < Sketchup::SelectionObserver
  def initialize(speckle_view)
    @speckle_view = speckle_view
  end

  def onSelectionCleared(selection)
    @speckle_view.on_selection_change
  end

  def onSelectionBulkChange(selection)
    @speckle_view.on_selection_change
  end
end