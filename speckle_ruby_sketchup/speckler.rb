require_relative 'sketchup_utils'
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

            t = SketchupUtils.get_global_transform(f)

            f.mesh.polygons.each {|arr|
              puts "FACE LENGTH: #{arr.length}"
              if arr.length == 3
                mesh.add_triangle(mesh_point(t, f.mesh, arr[0]),
                                  mesh_point(t, f.mesh, arr[1]),
                                  mesh_point(t, f.mesh, arr[2]))
              end
            }
          end

          #TODO support branching edges (this only works for independent loops)
          if f.kind_of? Sketchup::Edge
            puts "EDGE: #{f} #{f.vertices.length}"

            if f.all_connected.index(f) == 0 #we only want to add the interconnected edges once, so only add if this is the first edge
              puts "all_connected: #{f.all_connected.index(f)}"
              poly = SpecklePolyline.new

              t = SketchupUtils.get_global_transform(f)

              c_pos = f.all_connected[0].end.position
              poly.addPoint(c_pos.transform(t))

              chain, closed = chain_vertices(f.all_connected.select {|edge| edge.kind_of? Sketchup::Edge})
              puts "chain: #{chain}"
              puts "closed: #{closed}"
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


        # poly = SpecklePolyline.new
        # response.resources.push(poly)
        # poly.addPoint(f.mesh.point_at(p))

      end
    }

    json_data = response.to_json
    File.open('C:\\Temp\\speckleJsonData.json', 'w') {|file| file.write(json_data)}
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
end

Speckler.new.meshify

