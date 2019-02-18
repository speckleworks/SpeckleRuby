require_relative '../../speckle_ruby_core/extra/speckle_api_client'
class SketchupSpeckleReceiver
  def initialize(baseUrl)
    @speckle_api_client = SpeckleApiClient.new(baseUrl)
    @objects = [] # List<SpeckleObject> Objects
    @streamId = ''
    @paused = false
    @visible = true
  end
end