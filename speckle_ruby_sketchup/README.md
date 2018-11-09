# speckle_ruby_sketchup

SketchUp-specific implementation using speckle_ruby_core.

This package is a WIP and contains some very basic code to test exporting meshes and polylines from SketchUp into Speckle.

Current implementation exports user selection and saves it in a temp file.

## SpeckleView Dialog
SpeckleView implementation uses the standard [SpeckleView](https://github.com/speckleworks/SpeckleView) in a HtmlDialog. 
A custom Interop object is loaded into the HTML root to serve the same function as the [SpeckleRhino Interop C# Class](https://github.com/speckleworks/SpeckleRhino/blob/6693c13df266a6e0f88ac6824dccf8b4cf29fc74/SpeckleRhinoPlugin/src/Interop.cs)

