# speckle_ruby_core

Core objects from the Speckle Spec are defined in "speckle_ruby_core". 

Although the primary use case for Ruby is interfacing with SketchUp, no SketchUp objects should be referenced in core.

The full spec can be found here: 
https://speckleworks.github.io/SpeckleSpecs/

## JSON Serialization
Objects are designed to be serialized directly to JSON using the standard "to_json" method. Each object exposes properties to be serialized as JSON using a to_hash method and child classes merge their properties with their parents in this method.

For example the SpecklePolyline class extends SpeckleObject and defines a serialization Hash as follows:
```ruby
  def to_hash
    {
        :closed => @closed,
        :value => @value,
        :domain => @domain,
    }.merge(super.to_hash)
  end
```

## Spec Compliance
- [x] ResourceBase
- [ ] User
- [ ] AppClient
- [ ] Project
- [ ] Comment
- [ ] SpeckleStream
- [ ] Layer
- [ ] LayerProperties
- [x] ResponseBase
- [ ] ResponseUser
- [ ] ResponseClient
- [ ] ResponseProject
- [ ] ResponseComment
- [ ] ResponseStream
- [x] ResponseObject
- [ ] ResponseStreamClone
- [ ] ResponseStreamDiff
- [x] SpeckleObject
- [ ] SpeckleAbstract
- [x] SpecklePlaceholder
- [ ] SpeckleBoolean
- [ ] SpeckleNumber
- [ ] SpeckleString
- [ ] SpeckleInterval
- [ ] SpeckleInterval2d
- [ ] SpecklePoint
- [ ] SpeckleVector
- [ ] SpecklePlane
- [ ] SpeckleCircle
- [ ] SpeckleArc
- [ ] SpeckleEllipse
- [ ] SpecklePolycurve
- [ ] SpeckleBox
- [ ] SpeckleLine
- [x] SpecklePolyline
- [ ] SpeckleCurve
- [x] SpeckleMesh
- [ ] SpeckleBrep
- [ ] SpeckleExtrusion
- [ ] SpeckleAnnotation
- [ ] SpeckleBlock

## Extra
The extra subdirectory contains additional Speckle classes that are used, but not part of the official spec (yet)
- [x] SpeckleAccount
- [x] LayerSelection


