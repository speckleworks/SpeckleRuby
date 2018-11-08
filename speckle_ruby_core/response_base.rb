class ResponseBase #https://speckleworks.github.io/SpeckleSpecs/?ruby#schemaresponsebase
  attr_accessor :success #: true,
  attr_accessor :message #: "string",
  attr_accessor :resource #: {},
  attr_accessor :resources #: []

  def to_hash
    {
        :success => @success,
        :message => @message,
        :resources => @resources
    }
  end
end