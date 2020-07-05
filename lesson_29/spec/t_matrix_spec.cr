require "spec"
require "../core/toolbox/math/glm.cr"

describe "Matrix" do
  describe "new" do
    it "2x2" do
      m = 2
      n = 2
      matrix = GLM::Matrix.new(m,n)
      matrix.data.size().should eq m*n
    end

    it "2x2" do
      arr = [[1,2],[3,4]]
      matrix = GLM::Matrix.new(arr)
      matrix.rows.should eq 2
      matrix.columns.should eq 2
      matrix[0,0].should eq 1
      matrix[0,1].should eq 2
      matrix[1,0].should eq 3
      matrix[1,1].should eq 4
    end

  end

  describe "setter and getter [i,j] " do
    it "2x2" do
      rows = 2
      cols = 2
      matrix = GLM::Matrix.new(rows,cols)
      matrix[0,0] = 1
      matrix[0,1] = 2
      matrix[1,0] = 3
      matrix[1,1] = 4

      matrix[0,0].should eq 1
      matrix[0,1].should eq 2
      matrix[1,0].should eq 3
      matrix[1,1].should eq 4
    end

  end

  describe "getter negative [i,j] " do
    describe "negative row index" do
      it "2x2" do
        a = [
          [1,2],
          [3,4]
        ]
        m = GLM::Matrix.new(a)

        m[-1,0].should eq 3
        m[-2,0].should eq 1
      end
    end

    describe "negative column index" do
      it "2x2" do
        a = [
          [1,2],
          [3,4]
        ]
        m = GLM::Matrix.new(a)

        m[0,-1].should eq 2
        m[0,-2].should eq 1
      end
    end
  end

  describe "setter negative [i,j] " do
    describe "negative row index" do
      it "2x2" do
        m = GLM::Matrix.new(2,2)
        m[0,0] = 1
        m[0,1] = 2
        m[1,0] = 3
        m[1,1] = 4

        m[-1,0] = 12
        m[-2,0] = 21
        m[-1,0].should eq 12
        m[-2,0].should eq 21
      end
    end

    describe "negative column index" do
      it "2x2" do
        m = GLM::Matrix.new(2,2)
        m[0,0] = 1
        m[0,1] = 2
        m[1,0] = 3
        m[1,1] = 4

        m[0,-1] = 12
        m[0,-2] = 21

        m[0,-1].should eq 12
        m[0,-2].should eq 21
      end
    end

  end

  describe "diagonal() : GLM::Matrix" do
    it "2x2" do
      rows = 2
      cols = 2
      matrix = GLM::Matrix.new(rows,cols)
      matrix[0,0] = 1
      matrix[0,1] = 2
      matrix[1,0] = 3
      matrix[1,1] = 4

      r = matrix.diagonal()

      r[0,0].should eq 1
      r[0,1].should eq 0
      r[1,0].should eq 0
      r[1,1].should eq 4
    end

    it "3x3" do
      rows = 3
      cols = 3
      matrix = GLM::Matrix.new(rows,cols)
      matrix[0,0] = 1
      matrix[0,1] = 2
      matrix[0,2] = 3
      matrix[1,0] = 4
      matrix[1,1] = 5
      matrix[1,2] = 6
      matrix[2,0] = 7
      matrix[2,1] = 8
      matrix[2,2] = 9

      r = matrix.diagonal()

      r[0,0].should eq 1
      r[0,1].should eq 0
      r[0,2].should eq 0
      r[1,0].should eq 0
      r[1,1].should eq 5
      r[1,2].should eq 0
      r[2,0].should eq 0
      r[2,1].should eq 0
      r[2,2].should eq 9
    end
  end

  describe "transpose() : GLM::Matrix" do
    it "2x2" do
      rows = 2
      cols = 2
      matrix = GLM::Matrix.new(rows,cols)
      matrix[0,0] = 1
      matrix[0,1] = 2
      matrix[1,0] = 3
      matrix[1,1] = 4

      r = matrix.transpose()

      r[0,0].should eq 1
      r[0,1].should eq 3
      r[1,0].should eq 2
      r[1,1].should eq 4
    end
  end

  describe "GLM::Matrix.identity(n : Int32) : GLM::Matrix" do
    it "2x2" do
      n = 2
      matrix = GLM::Matrix.identity(n)
      matrix[0,0].should eq 1
      matrix[0,1].should eq 0
      matrix[1,0].should eq 0
      matrix[1,1].should eq 1

    end

    it "3x3" do
      n = 3
      matrix = GLM::Matrix.identity(n)
      matrix[0,0].should eq 1
      matrix[0,1].should eq 0
      matrix[0,2].should eq 0
      matrix[1,0].should eq 0
      matrix[1,1].should eq 1
      matrix[1,2].should eq 0
      matrix[2,0].should eq 0
      matrix[2,1].should eq 0
      matrix[2,2].should eq 1
    end
  end

  describe "Matrix.zero(n : Int32) : GLM::Matrix" do
    it "2x2" do
      n = 2
      matrix = GLM::Matrix.zero(n)
      matrix[0,0] = 0
      matrix[0,1] = 0
      matrix[1,0] = 0
      matrix[1,1] = 0

    end

    it "3x3" do
      n = 3
      matrix = GLM::Matrix.zero(n)
      matrix[0,0] = 0
      matrix[0,1] = 0
      matrix[0,2] = 0
      matrix[1,0] = 0
      matrix[1,1] = 0
      matrix[1,2] = 0
      matrix[2,0] = 0
      matrix[2,1] = 0
      matrix[2,2] = 0
    end
  end

  describe "m1 * m2" do
    it "2x2" do
      m1 = GLM::Matrix.new([[1,0],[0,1]])
      m2 = GLM::Matrix.new([[1,0],[0,1]])

      m3 = m1 * m2
      m3.rows.should eq 2
      m3.columns.should eq 2

      m3[0,0].should eq 1
      m3[0,1].should eq 0
      m3[1,0].should eq 0
      m3[1,1].should eq 1

      m1 = GLM::Matrix.new([[1,0],[0,1]])
      m2 = GLM::Matrix.new([[1,2],[3,4]])

      m3 = m1 * m2
      m3.rows.should eq 2
      m3.columns.should eq 2

      m3[0,0].should eq 1
      m3[0,1].should eq 2
      m3[1,0].should eq 3
      m3[1,1].should eq 4
    end

    it "3x3" do
      m1 = GLM::Matrix.new([[1,0,0],[0,1,0],[0,0,1]])
      m2 = GLM::Matrix.new([[1,0,0],[0,1,0],[0,0,1]])

      m3 = m1 * m2
      m3.rows.should eq 3
      m3.columns.should eq 3

      m3[0,0].should eq 1
      m3[0,1].should eq 0
      m3[0,2].should eq 0

      m3[1,0].should eq 0
      m3[1,1].should eq 1
      m3[1,2].should eq 0

      m3[2,0].should eq 0
      m3[2,1].should eq 0
      m3[2,2].should eq 1

      m1 = GLM::Matrix.new([[1,0,0],[0,1,0],[0,0,1]])
      m2 = GLM::Matrix.new([[1,2,3],[4,5,6],[7,8,9]])

      m3 = m1 * m2
      m3.rows.should eq 3
      m3.columns.should eq 3

      m3[0,0].should eq 1
      m3[0,1].should eq 2
      m3[0,2].should eq 3

      m3[1,0].should eq 4
      m3[1,1].should eq 5
      m3[1,2].should eq 6

      m3[2,0].should eq 7
      m3[2,1].should eq 8
      m3[2,2].should eq 9

    end
  end

  describe "Float64 * m" do
    it "2x2" do
      m1 = GLM::Matrix.new([[1,0],[0,1]])

      a = 2.5f32
      m3 = a * m1
      m3.rows.should eq 2
      m3.columns.should eq 2

      m3[0,0].should eq 2.5
      m3[0,1].should eq 0
      m3[1,0].should eq 0
      m3[1,1].should eq 2.5

    end

    it "3x3" do
      m1 = GLM::Matrix.new([[1,0,0],[0,1,0],[0,0,1]])

      a = 2.5f32
      m3 = a * m1
      m3.rows.should eq 3
      m3.columns.should eq 3

      m3[0,0].should eq 2.5
      m3[0,1].should eq 0
      m3[0,2].should eq 0

      m3[1,0].should eq 0
      m3[1,1].should eq 2.5
      m3[1,2].should eq 0

      m3[2,0].should eq 0
      m3[2,1].should eq 0
      m3[2,2].should eq 2.5
    end
  end

  describe "Int32 * m" do
    it "2x2" do
      m1 = GLM::Matrix.new([[1,0],[0,1]])

      a = 2
      m3 = a * m1
      m3.rows.should eq 2
      m3.columns.should eq 2

      m3[0,0].should eq 2
      m3[0,1].should eq 0
      m3[1,0].should eq 0
      m3[1,1].should eq 2

    end

    it "3x3" do
      m1 = GLM::Matrix.new([[1,0,0],[0,1,0],[0,0,1]])

      a = 2
      m3 = a * m1
      m3.rows.should eq 3
      m3.columns.should eq 3
      m3[0,0].should eq 2
      m3[0,1].should eq 0
      m3[0,2].should eq 0

      m3[1,0].should eq 0
      m3[1,1].should eq 2
      m3[1,2].should eq 0

      m3[2,0].should eq 0
      m3[2,1].should eq 0
      m3[2,2].should eq 2
    end
  end
end

describe "matrix * vector" do

  describe "m1 * v1" do

    it "4x4 * 4x1" do
      m = GLM::Matrix.identity(4)
      v = GLM::Vector4.new(2,3,4,5)

      m3 = m * v

      #m3.size.should eq 3
      m3[0].should eq 2
      m3[1].should eq 3
      m3[2].should eq 4

    end
  end
end

describe "determinant() : Float32" do
  it "2x2" do
    m = GLM::Matrix.new([[1,0],[0,1]])
    m.determinant.should eq 1

    m = GLM::Matrix.new([[1,2],[3,4]])
    m.determinant.should eq -2
  end

  it "3x3" do
    m = GLM::Matrix.new( [[1,0,0],[0,1,0],[0,0,1]])
    m.determinant().should eq 1

    m = GLM::Matrix.new( [[1,0,0],[0,2,0],[0,0,1]])
    m.determinant.should eq 2
  end

  it "4x4" do
    m = GLM::Matrix.new( [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]])
    m.determinant().should eq 1

    m = GLM::Matrix.new( [[1,0,0,0],[0,2,0,0],[0,0,1,0],[0,0,0,3]])
    m.determinant.should eq 6
  end

  it "5x5" do
    m = GLM::Matrix.new( [[1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,0,0,1]])
    m.determinant().should eq 1

    m = GLM::Matrix.new( [[1,0,0,0,0],[0,2,0,0,0],[0,0,3,0,0],[0,0,0,4,0],[0,0,0,0,5]])
    m.determinant().should eq 120
  end
end

describe "adjoint() : GLM::Matrix" do
  it "2x2" do
    arr = [
      [1 , 2],
      [3 , 4]
    ]

    m = GLM::Matrix.new(arr)
    r = m.adjoint()

    expected = GLM::Matrix.new([[4,-2],[-3,1]])
    flag = expected == r
    flag.should eq true

    # A * adjoint(A) == det(A) * identity()
    mr = m * m.adjoint()
    expected = m.determinant() * GLM::Matrix.identity(2)

    flag = mr == expected
    flag.should eq true
  end

  it "3x3" do
    arr = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 10]
    ]
    m = GLM::Matrix.new(arr)
    m.determinant().should eq -3

    r = m.adjoint()

    expected = GLM::Matrix.new([[2,4,-3],[2,-11,6],[-3,6,-3]])
    flag = expected == r
    flag.should eq true

    # A * adjoint(A) == det(A) * identity()
    mr = m * m.adjoint()
    expected = m.determinant() * GLM::Matrix.identity(3)

    flag = mr == expected
    flag.should eq true

  end

  it "4x4" do
    arr = [
      [5 , -2,  2,  7],
      [1 ,  0,  0,  3],
      [-3,  1,  5,  0],
      [3 , -1, -9,  4]
    ]

    m = GLM::Matrix.new(arr)
    r = m.adjoint()

    expected = GLM::Matrix.new([
                  [-12,   76, -60,  -36],
                  [-56,  208, -82,  -58],
                  [4  ,   4 ,  -2,  -10],
                  [4  ,   4 ,  20,   12]
                ])
    flag = expected == r
    flag.should eq true

    # A * adjoint(A) == det(A) * identity()
    mr = m * m.adjoint()
    expected = m.determinant() * GLM::Matrix.identity(4)

    flag = mr == expected
    flag.should eq true
  end
end

describe "inverse() : GLM::Matrix" do
  it "2x2" do
    arr = [
      [1 , 2],
      [3 , 4]
    ]

    m = GLM::Matrix.new(arr)
    r = m.inverse()
    r.should eq GLM::Matrix.new([
                [-2.0, 1.0],
                [1.5, -0.5]
              ])

    # test A * A.inverse() = GLM::Matrix.identity(2)
    atimesainv = m * r

    flag = atimesainv == GLM::Matrix.identity(2)
    flag.should eq true

    atimesainv.should eq GLM::Matrix.new([
                  [1.0, 0.0],
                  [0.0, 1.0]
                ])
  end

  it "3x3" do
    arr = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 10]
    ]

    m = GLM::Matrix.new(arr)
    r = m.inverse()
    r.should eq GLM::Matrix.new([
                  [-0.6666666666666666, -1.3333333333333333, 1.0],
                  [-0.6666666666666666, 3.6666666666666665, -2.0],
                  [1.0, -2.0, 1.0]
                ])

    # test A * A.inverse() = GLM::Matrix.identity(3)
    atimesainv = m * r

    flag = atimesainv == GLM::Matrix.identity(3)
    flag.should eq true

  end

  it "4x4" do
    arr = [
      [5 , -2,  2,  7],
      [1 ,  0,  0,  3],
      [-3,  1,  5,  0],
      [3 , -1, -9,  4]
    ]

    m = GLM::Matrix.new(arr)
    r = m.inverse()
    r.should eq GLM::Matrix.new([
                  [-0.13636363636363635, 0.8636363636363636, -0.6818181818181818, -0.4090909090909091],
                  [-0.6363636363636364, 2.3636363636363638, -0.9318181818181818, -0.6590909090909091],
                  [0.045454545454545456, 0.045454545454545456, -0.022727272727272728, -0.11363636363636363],
                  [0.045454545454545456, 0.045454545454545456, 0.22727272727272727, 0.13636363636363635]
                ])

    # test A * A.inverse() = GLM::Matrix.identity(4)
    atimesainv = m * r

    atimesainv[0,0].should be_close(1.0,0.000001)
    atimesainv[0,1].should be_close(0.0,0.000001)
    atimesainv[0,2].should be_close(0.0,0.000001)
    atimesainv[0,3].should be_close(0.0,0.000001)

    atimesainv[1,0].should be_close(0.0,0.000001)
    atimesainv[1,1].should be_close(1.0,0.000001)
    atimesainv[1,2].should be_close(0.0,0.000001)
    atimesainv[1,3].should be_close(0.0,0.000001)

    atimesainv[2,0].should be_close(0.0,0.000001)
    atimesainv[2,1].should be_close(0.0,0.000001)
    atimesainv[2,2].should be_close(1.0,0.000001)
    atimesainv[2,3].should be_close(0.0,0.000001)

    atimesainv[3,0].should be_close(0.0,0.000001)
    atimesainv[3,1].should be_close(0.0,0.000001)
    atimesainv[3,2].should be_close(0.0,0.000001)
    atimesainv[3,3].should be_close(1.0,0.000001)
  end
end
