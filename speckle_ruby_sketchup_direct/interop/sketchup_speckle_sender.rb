require_relative '../../speckle_ruby_core/extra/speckle_api_client'
class SketchupSpeckleSender
  def initialize(payloadHash)
    @objects = [] # List<SpeckleObject> Objects
    @streamId = ''
    @paused = false
    @visible = true
    @isSendingUpdate = false
    @expired = false

    @streamName = payloadHash.streamName
    @client = SpeckleApiClient.new(payloadHash.account.restApi)
    @client.initialize_sender(payloadHash.account.apiToken, document_name, 'SketchUp', document_guid)

    # TODO it looks like all these events just notify using a client-expired event and then resend the data on a timer tick
    # RhinoDoc.ModifyObjectAttributes += RhinoDoc_ModifyObjectAttributes;
    # RhinoDoc.DeleteRhinoObject += RhinoDoc_DeleteRhinoObject;
    # RhinoDoc.AddRhinoObject += RhinoDoc_AddRhinoObject;
    # RhinoDoc.UndeleteRhinoObject += RhinoDoc_UndeleteRhinoObject;
    # RhinoDoc.LayerTableEvent += RhinoDoc_LayerTableEvent;

    # Context.NotifySpeckleFrame( "client-expired", StreamId, "" );
    # Actual sending is done using the "SendStaggeredUpdate" method
    # Rhino objects are serialized using Converter.Serialise( obj.Geometry );



  end

  def document_guid
    'TODO'
  end

  def document_name
    'TODO'
  end

  def send
    Net::HTTP.post_form(uri, 'data' => jsonData).body
  end
end