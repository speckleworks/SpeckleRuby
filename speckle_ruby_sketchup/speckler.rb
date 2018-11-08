require_relative '../speckle_ruby_core/response_object'
require_relative '../speckle_ruby_core/speckle_mesh'
require_relative '../speckle_ruby_core/speckle_polyline'

class Speckler
  def meshify
    model = Sketchup.active_model
    ss = model.selection

    if ss.empty?
      UI.messagebox('Please select some groups')
      return
    end

    # I think the basic process here is to generate a single mesh from all faces
    # run through each face and store vertices by index (hash string?)
    # then go through all polygons and generate triangles array corresponding to new index positions
    # I think polygons are a series of triangles (they look like 3x)

    response = ResponseObject.new

    ss.each {|e|
      if e.kind_of? Sketchup::Group

        mesh = nil
        poly = nil

        e.entities.each {|f|
          if f.kind_of? Sketchup::Face
            unless mesh
              mesh = SpeckleMesh.new
            end

            f.mesh.polygons.each {|arr|
              puts "FACE LENGTH: #{arr.length}"
              if arr.length == 3
                mesh.add_triangle(f.mesh.point_at(arr[0]), f.mesh.point_at(arr[1]), f.mesh.point_at(arr[2]))
              end
            }
          end

          #TODO support branching edges (this only works for independent loops)
          if f.kind_of? Sketchup::Edge
            puts "EDGE: #{f} #{f.vertices.length}"
            puts "all_connected: #{f.all_connected.index(f)}"
            if f.all_connected.index(f) == 0 #we only want to add the interconnected edges once, so only add if this is the first edge
              poly = SpecklePolyline.new

              poly.addPoint(f.all_connected[0].start.position)
              f.all_connected.each {|edge|
                poly.addPoint(edge.end.position)
              }

              poly.closed = f.all_connected[0].start.position == f.all_connected[-1].end.position

              response.resources.push(poly)
            end

          end

        }

        if mesh
          response.resources.push(mesh)
        end


        # poly = SpecklePolyline.new
        # response.resources.push(poly)
        # poly.addPoint(f.mesh.point_at(p))

      end
    }

    json_data = response.to_json
    File.open('C:\\Temp\\speckleJsonData.json', 'w') {|file| file.write(json_data)}

  end
end

Speckler.new.meshify