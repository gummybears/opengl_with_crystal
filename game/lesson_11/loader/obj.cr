#
# obj.cr
#
require "../core/errors.cr"
require "./face.cr"
require "../math/**"

NOINDEX = -1

class OBJ
  property filename            : String = ""
  property error               : String = ""
  property normals             : Array(GLM::Vec3)
  property vertices            : Array(GLM::Vec4)
  property texture_coordinates : Array(GLM::Vec3)
  property faces               : Array(WaveFront::Face)

  # used to convert OBJ data to OpenGL arrays
  property vertices_arr        : Array(Float32)
  property textures_arr        : Array(Float32)
  property normals_arr         : Array(Float32)
  property indices_arr         : Array(Int32)

  def initialize
    @normals             = [] of GLM::Vec3
    @vertices            = [] of GLM::Vec4
    @texture_coordinates = [] of GLM::Vec3
    @faces               = [] of WaveFront::Face

    @vertices_arr        = [] of Float32
    @normals_arr         = [] of Float32
    @textures_arr        = [] of Float32
    @indices_arr         = [] of Int32
  end

  def open(filename : String)
    @filename = filename
    filenotfound(filename)

    lines = File.read_lines(filename)
    if lines.size() == 0
      report_error("file '#{filename}' contains no data")
    end

    parse(lines)
  end

  def split_face(arr : Array(String) ) : WaveFront::Face

    vi  = NOINDEX
    vti = NOINDEX
    vni = NOINDEX

    elements = [] of WaveFront::FaceElement
    arr.each do |e|

      x = e.split("/")
      if x.size > 0
        if x[0].size > 0
          vi = x[0].to_i

          if vi < 0
            report_error("only positive indices are supported")
          end
        end
      end

      if x.size == 2
        if x[1].size > 0
          vti = x[1].to_i

          if vti < 0
            report_error("only positive indices are supported")
          end
        end
      end

      if x.size == 3
        if x[1].size > 0
          vti = x[1].to_i

          if vti < 0
            report_error("only positive indices are supported")
          end
        end

        if x[2].size > 0
          vni = x[2].to_i

          if vni < 0
            report_error("only positive indices are supported")
          end
        end

      end

      elements << WaveFront::FaceElement.new(vi,vti,vni)
    end

    face = WaveFront::Face.new(elements)
    return face
  end

  def parse(lines : Array(String))

    lines.each do |line|
      components = line.split

      type = ""
      if components.size > 0
        type = components.shift
      end

      case type

        when "#"
          # comments

        when "mtllib"
          #report_warning("OBJ mtllib not implemented")

        when "usemtl"
          #report_warning("OBJ usemtl not implemented")

        when "v"
          if components.size() < 3
            report_error("#{@filename} has invalid vertex data")
          end

          x = components[0].to_f32
          y = components[1].to_f32
          z = components[2].to_f32
          w = 0.0f32
          if components.size() == 4
            w = components[3].to_f32
          else
            w = 1.0f32
          end
          @vertices << GLM::Vec4.new(x,y,z,w)

        when "vt"

          u = 0.0f32
          v = 0.0f32
          w = 0.0f32
          if components.size() < 1
            report_error("#{@filename} has invalid texture vertex data")
          end

          u = components[0].to_f32
          if components.size() == 2
            v = components[1].to_f32
          end

          if components.size() == 3
            w = components[2].to_f32
          end

          @texture_coordinates << GLM::Vec3.new(u,v,w)

        when "vn"
          if components.size() != 3
            report_error("#{@filename} has invalid normal data")
          end

          x = components[0].to_f32
          y = components[1].to_f32
          z = components[2].to_f32
          @normals << GLM::Vec3.new(x,y,z)

        when "vp"

        when "f"
          f = split_face(components)
          @faces << f

        when "g"

        when "s"

        when "o"

        else
          # Crystal 0.34
      end # case
    end
  end

  def checks()
    if @faces.size() == 0
      report_error("#{@filename} has no face data")
    end

    if @vertices.size() == 0
      report_error("#{@filename} has no vertex data")
    end
  end

  #
  # convert the OBJ data into array format (OpenGL)
  #
  #
  # loop over all faces
  # Note: face indices start at 1, subtract 1 to start at 0
  #
  def to_opengl

    nr_vertices = @vertices.size

    #
    # allocate arrays
    #
    @vertices_arr        = Array.new(nr_vertices * 3) {0.0f32}
    @normals_arr         = Array.new(nr_vertices * 3) {0.0f32}
    @textures_arr        = Array.new(nr_vertices * 2) {0.0f32}
    @indices_arr         = [] of Int32

    @faces.each do |face|

      vi  = NOINDEX
      vti = NOINDEX
      vni = NOINDEX

      face.elements.each do |elem|

        vi  = elem.vi
        vti = elem.vti
        vni = elem.vni

        if vi == 0
          puts "OBJ face vertex index should be greater than 0"
          exit
        end

        if vti == 0
          puts "OBJ face texture index should be greater than 0"
          exit
        end

        if vni == 0
          puts "OBJ face normal index should be greater than 0"
          exit
        end

        #
        # adjust the OBJ indices
        #
        if vi > 0
          vi = vi - 1
        end

        if vti > 0
          vti = vti - 1
        end

        if vni > 0
          vni = vni - 1
        end

        #
        # process each face
        # store the vertices
        # texture coordinates
        # and normals
        #
        if vi >= 0
          vertex = @vertices[vi]

          @vertices_arr[vi*3]   = vertex.x
          @vertices_arr[vi*3+1] = vertex.y
          @vertices_arr[vi*3+2] = vertex.z
        end

        # store the texture coordinates
        if vti >= 0

          texture = @texture_coordinates[vti]
          #
          # some 3D programs like blender export the y coordinate of
          # textures differently
          # big assumption here, as there is no guarantee
          # other 3D programs do this as well
          #
          @textures_arr[vi*2]   = texture.x
          @textures_arr[vi*2+1] = 1.0f32 - texture.y

        end

        # store the normals
        if vni >= 0
          normal = @normals[vni]
          @normals_arr[vi*3]   = normal.x
          @normals_arr[vi*3+1] = normal.y
          @normals_arr[vi*3+2] = normal.z

        end

        # and fill in the indices
        if vi >= 0
          @indices_arr << vi
        end

      end
    end # each face
  end # to_a
end
