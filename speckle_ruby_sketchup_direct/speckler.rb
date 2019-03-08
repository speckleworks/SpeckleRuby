require_relative 'sketchup_utils'
require_relative '../speckle_ruby_core/response_object'
require_relative '../speckle_ruby_core/speckle_mesh'
require_relative '../speckle_ruby_core/speckle_polyline'
require_relative '../speckle_ruby_core/speckle_camera'

class Speckler
  def create_speckle_objects(ss, types = ['face', 'edge'])
    response = ResponseObject.new

    ss.each {|e|
      if e.kind_of? Sketchup::Group

        mesh = nil
        poly = nil

        e.entities.each {|f|
          if types.include?('face') and f.kind_of? Sketchup::Face
            unless mesh
              mesh = SpeckleMesh.new
              mesh.name = e.name
              mesh.colors = ['#ffffff']
              if e.material
                mesh.colors = [SketchupUtils.color_to_hex(e.material.color)]
              end
            end

            #t = SketchupUtils.get_global_transform(f) -- global transform doesn't work with "instanced" groups
            t = e.transformation

            f.mesh.polygons.each {|arr|
              # puts "FACE LENGTH: #{arr.length}"
              if arr.length == 3
                mesh.add_triangle(mesh_point(t, f.mesh, arr[0]),
                                  mesh_point(t, f.mesh, arr[1]),
                                  mesh_point(t, f.mesh, arr[2]))
              end
            }
          end

          if types.include?('edge') and f.kind_of? Sketchup::Edge
            # puts "ALL CONNECTED: #{f.all_connected}"

            all_connected_edges = f.all_connected.select {|edge| edge.kind_of? Sketchup::Edge}

            # puts "EDGE: #{all_connected_edges.index(f)} ... #{f.vertices.length}"


            if all_connected_edges.index(f) == 0 #we only want to add the interconnected edges once, so only add if this is the first edge
              # puts "all_connected: #{all_connected_edges.index(f)}"
              poly = SpecklePolyline.new
              poly.name = e.name
              # t = SketchupUtils.get_global_transform(f)
              t = e.transformation

              c_pos = all_connected_edges[0].end.position
              poly.addPoint(c_pos.transform(t))

              chain, closed = chain_vertices(all_connected_edges)
              # puts "chain: #{chain}"
              # puts "closed: #{closed}"
              if chain
                chain.each {|v|
                  poly.addPoint(v.position.transform(t))
                }
              end

              poly.closed = closed

              response.resources.push(poly)
            end

          end
        }

        if mesh
          response.resources.push(mesh)
        end
      end
    }

    response
  end

  def chain_vertices(edges)
    edges.uniq!

    vertices = []
    edges.each {|edge|
      vertices.push(edge.end)
      vertices.push(edge.start)
    }

    open = false
    open_vertex = nil
    vertices.each {|v|
      if v.edges.length > 2
        return false #we don't support branching polylines -- we should export as lines instead
      end
      if v.edges.length < 2
        open = true
        open_vertex = v
      end
    }

    if open
      chain = []
      c_vertex = open_vertex
      c_edge = open_vertex.edges[0]
      chain.push(c_vertex)
      while c_edge
        n_vertex = c_edge.other_vertex(c_vertex)
        c_edge = other_edge(n_vertex, c_edge)
        c_vertex = n_vertex
        chain.push(c_vertex)
      end

      return chain, false
    end

    chain = []
    c_vertex = vertices[0]
    c_edge = c_vertex.edges[0]
    chain.push(c_vertex)
    while c_edge
      n_vertex = c_edge.other_vertex(c_vertex)
      c_edge = other_edge(n_vertex, c_edge)
      c_vertex = n_vertex
      if c_vertex == vertices[0]
        break
      end
      chain.push(c_vertex)
    end

    return chain, true
  end

  def other_edge(vertex, edge)
    if vertex.edges.length != 2
      return false
    end
    if vertex.edges[0] == edge
      return vertex.edges[1]
    end
    vertex.edges[0]
  end

  def mesh_point(transform, mesh, index)
    pt = mesh.point_at(index)
    pt.transform(transform)
  end

  def create_camera_response(camera)
    response = ResponseObject.new
    cam = SpeckleCamera.new
    cam.eye = [camera.eye[0].to_f, camera.eye[1].to_f, camera.eye[2].to_f]
    cam.target = [camera.target[0].to_f, camera.target[1].to_f, camera.target[2].to_f]
    cam.up = [camera.up[0], camera.up[1], camera.up[2]]
    if camera.perspective?
      cam.fov = camera.fov
    end
    response.resources.push(cam)
    response
  end
end

