class SpeckleRubySender
  def initialize(payload, interop)
    @client = SpeckleApiClient.new(payload.account.restApi)
    @stream_name = payload.streamName

    #TODO context.NotifySpeckleFrame( "set-gl-load", "", "true" )
    #
    @client.initialize_sender(payload.account.apiToken, interop.document_name, "SketchUp", interop.document_guid)

    # StreamId = Client.Stream.StreamId;
    # Client.Stream.Name = StreamName;
    #
    # Context.NotifySpeckleFrame( "set-gl-load", "", "false" );
    # Context.NotifySpeckleFrame( "client-add", StreamId, JsonConvert.SerializeObject( new { stream = Client.Stream, client = Client } ) );
    # Context.UserClients.Add( this );
    #
    init_tracked_objects(payload)
    # DataSender.Start();
    #

    #TODO var objs = RhinoDoc.ActiveDoc.Objects.FindByUserString( "spk_" + this.StreamId, "*", false ).OrderBy( obj => obj.Attributes.LayerIndex );

    # int lindex = -1, count = 0, orderIndex = 0;
    # foreach ( RhinoObject obj in objs )
    # {
    #     // layer list creation
    # Rhino.DocObjects.Layer layer = RhinoDoc.ActiveDoc.Layers[ obj.Attributes.LayerIndex ];
    # if ( lindex != obj.Attributes.LayerIndex )
    #   {
    #       var spkLayer = new SpeckleCore.Layer()
    #   {
    #       Name = layer.FullPath,
    #       Guid = layer.Id.ToString(),
    #       ObjectCount = 1,
    #       StartIndex = count,
    #       OrderIndex = orderIndex++,
    #       Properties = new LayerProperties() { Color = new SpeckleCore.SpeckleBaseColor() { A = 1, Hex = System.Drawing.ColorTranslator.ToHtml( layer.Color ) }, }
    #   };
    #
    #   pLayers.Add( spkLayer );
    #   lindex = obj.Attributes.LayerIndex;
    #   }
    # else
    #   {
    #       var spkl = pLayers.FirstOrDefault( pl => pl.Name == layer.FullPath );
    #   spkl.ObjectCount++;
    #   }
    #
    #   count++;
    #
    #   // object conversion
    #   SpeckleObject convertedObject;
    #
    #   convertedObject = Converter.Serialise( obj.Geometry );
    #   convertedObject.ApplicationId = obj.Id.ToString();
    #   convertedObject.Name = obj.Name;
    #   allObjects.Add( convertedObject );



  end

  def init_tracked_objects(payload)
    payload.selection.each do |guid|
      #TODO store guid on SketchUp object .Attributes.SetUserString( "spk_" + StreamId, StreamId );
    end
  end
end