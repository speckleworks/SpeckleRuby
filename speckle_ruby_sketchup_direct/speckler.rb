require_relative 'sketchup_utils'
require_relative '../speckle_ruby_core/response_object'
require_relative '../speckle_ruby_core/speckle_mesh'
require_relative '../speckle_ruby_core/speckle_polyline'

class Speckler
  def create_speckle_objects(ss)
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
              # puts "FACE LENGTH: #{arr.length}"
              if arr.length == 3
                mesh.add_triangle(mesh_point(t, f.mesh, arr[0]),
                                  mesh_point(t, f.mesh, arr[1]),
                                  mesh_point(t, f.mesh, arr[2]))
              end
            }
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
end

