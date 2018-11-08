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

    ss.each {|e|
      if e.kind_of? Sketchup::Group

        response = ResponseObject.new

        mesh = SpeckleMesh.new
        poly = SpecklePolyline.new

        response.resources.push(mesh)
        response.resources.push(poly)

        jsonData = response.to_json
        File.open('C:\\Temp\\speckleJsonData.json', 'w') {|file| file.write(jsonData)}

        e.entities.each {|f|
          if f.kind_of? Sketchup::Face
            puts f.mesh
            f.mesh.polygons.each {|arr|
              puts "FACE LENGTH: #{arr.length}"
              if arr.length == 3
                mesh.add_triangle(f.mesh.point_at(arr[0]), f.mesh.point_at(arr[1]), f.mesh.point_at(arr[2]))
              end
              arr.each {|p|
                #NOTE - values here mean a hidden edge
                puts "#{p} #{f.mesh.point_at(p)}"
                poly.addPoint(f.mesh.point_at(p))
              }
            }
          end

        }
      end
    }

  end
end

Speckler.new.meshify