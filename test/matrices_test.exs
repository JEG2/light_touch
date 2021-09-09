defmodule LightTouch.MatricesTest do
  use ExUnit.Case, async: true

  import LightTouch.TestSupport.Comparisons
  alias LightTouch.{Primitives, Operations}

  test "matrix creation" do
    matrix =
      Primitives.matrix(
        {1, 2, 3, 4},
        {5.5, 6.5, 7.5, 8.5},
        {9, 10, 11, 12},
        {13.5, 14.5, 15.5, 16.5}
      )

    assert element(matrix, {0, 0}) == 1
    assert element(matrix, {1, 0}) == 5.5
    assert element(matrix, {1, 2}) == 7.5
    assert element(matrix, {2, 2}) == 11
    assert element(matrix, {3, 0}) == 13.5
    assert element(matrix, {3, 2}) == 15.5

    matrix =
      Primitives.matrix(
        {-3, 5},
        {1, -2}
      )

    assert element(matrix, {0, 0}) == -3
    assert element(matrix, {0, 1}) == 5
    assert element(matrix, {1, 0}) == 1
    assert element(matrix, {1, 1}) == -2

    matrix =
      Primitives.matrix(
        {-3, 5, 0},
        {1, -2, -7},
        {0, 1, 1}
      )

    assert element(matrix, {0, 0}) == -3
    assert element(matrix, {1, 1}) == -2
    assert element(matrix, {2, 2}) == 1
  end

  test "matrix equality" do
    matrix1 =
      Primitives.matrix(
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 8, 7, 6},
        {5, 4, 3, 2}
      )

    matrix2 =
      Primitives.matrix(
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 8, 7, 6},
        {5, 4, 3, 2}
      )

    assert close_to(matrix1, matrix2)

    matrix3 =
      Primitives.matrix(
        {2, 3, 4, 5},
        {6, 7, 8, 9},
        {8, 7, 6, 5},
        {4, 3, 2, 1}
      )

    refute close_to(matrix1, matrix3)
  end

  test "matrix multiplication" do
    matrix1 =
      Primitives.matrix(
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 8, 7, 6},
        {5, 4, 3, 2}
      )

    matrix2 =
      Primitives.matrix(
        {-2, 1, 2, 3},
        {3, 2, 1, -1},
        {4, 3, 6, 5},
        {1, 2, 7, 8}
      )

    product = Operations.multiply(matrix1, matrix2)

    assert close_to(
             product,
             Primitives.matrix(
               {20, 22, 50, 48},
               {44, 54, 114, 108},
               {40, 58, 110, 102},
               {16, 26, 46, 42}
             )
           )

    matrix =
      Primitives.matrix(
        {1, 2, 3, 4},
        {2, 4, 4, 2},
        {8, 6, 4, 1},
        {0, 0, 0, 1}
      )

    tuple = Primitives.point(1, 2, 3)
    product = Operations.multiply(matrix, tuple)
    assert close_to(product, Primitives.point(18, 24, 33))
  end

  test "identity matrix multiplication" do
    matrix =
      Primitives.matrix(
        {0, 1, 2, 4},
        {1, 2, 4, 8},
        {2, 4, 8, 16},
        {4, 8, 16, 32}
      )

    product = Operations.multiply(matrix, Primitives.identity_matrix())
    assert close_to(product, matrix)

    tuple = {1, 2, 3, 4}
    product = Operations.multiply(tuple, Primitives.identity_matrix())
    assert close_to(product, tuple)
  end

  test "transposing matrices" do
    matrix =
      Primitives.matrix(
        {0, 9, 3, 0},
        {9, 8, 0, 8},
        {3, 0, 5, 5},
        {0, 8, 3, 8}
      )

    transposed = Operations.transpose(matrix)

    assert close_to(
             transposed,
             Primitives.matrix(
               {0, 9, 3, 0},
               {9, 8, 0, 8},
               {3, 0, 5, 3},
               {0, 8, 5, 8}
             )
           )

    transposed = Operations.transpose(Primitives.identity_matrix())
    assert close_to(transposed, Primitives.identity_matrix())
  end

  test "calculating matrix determinants" do
    matrix =
      Primitives.matrix(
        {1, 5},
        {-3, 2}
      )

    determinant = Operations.determinant(matrix)
    assert close_to(determinant, 17)
  end

  test "submatrices" do
    matrix =
      Primitives.matrix(
        {1, 5, 0},
        {-3, 2, 7},
        {0, 6, -3}
      )

    submatrix = Operations.submatrix(matrix, {0, 2})

    assert close_to(
             submatrix,
             Primitives.matrix(
               {-3, 2},
               {0, 6}
             )
           )

    matrix =
      Primitives.matrix(
        {-6, 1, 1, 6},
        {-8, 5, 8, 6},
        {-1, 0, 8, 2},
        {-7, 1, -1, 1}
      )

    submatrix = Operations.submatrix(matrix, {2, 1})

    assert close_to(
             submatrix,
             Primitives.matrix(
               {-6, 1, 6},
               {-8, 8, 6},
               {-7, -1, 1}
             )
           )
  end

  test "calculating matrix minors" do
    matrix =
      Primitives.matrix(
        {3, 5, 0},
        {2, -1, -7},
        {6, -1, 5}
      )

    minor = Operations.minor(matrix, {1, 0})
    assert close_to(minor, 25)
  end

  test "calculating matrix cofactors" do
    matrix =
      Primitives.matrix(
        {3, 5, 0},
        {2, -1, -7},
        {6, -1, 5}
      )

    minor = Operations.minor(matrix, {0, 0})
    assert close_to(minor, -12)
    cofactor = Operations.cofactor(matrix, {0, 0})
    assert close_to(cofactor, -12)
    minor = Operations.minor(matrix, {1, 0})
    assert close_to(minor, 25)
    cofactor = Operations.cofactor(matrix, {1, 0})
    assert close_to(cofactor, -25)
  end

  test "calculating determinants for larger matrices" do
    matrix =
      Primitives.matrix(
        {1, 2, 6},
        {-5, 8, -4},
        {2, 6, 4}
      )

    cofactor = Operations.cofactor(matrix, {0, 0})
    assert close_to(cofactor, 56)
    cofactor = Operations.cofactor(matrix, {0, 1})
    assert close_to(cofactor, 12)
    cofactor = Operations.cofactor(matrix, {0, 2})
    assert close_to(cofactor, -46)
    determinant = Operations.determinant(matrix)
    assert close_to(determinant, -196)

    matrix =
      Primitives.matrix(
        {-2, -8, 3, 5},
        {-3, 1, 7, 3},
        {1, 2, -9, 6},
        {-6, 7, 7, -9}
      )

    cofactor = Operations.cofactor(matrix, {0, 0})
    assert close_to(cofactor, 690)
    cofactor = Operations.cofactor(matrix, {0, 1})
    assert close_to(cofactor, 447)
    cofactor = Operations.cofactor(matrix, {0, 2})
    assert close_to(cofactor, 210)
    cofactor = Operations.cofactor(matrix, {0, 3})
    assert close_to(cofactor, 51)
    determinant = Operations.determinant(matrix)
    assert close_to(determinant, -4071)
  end

  test "matrix invertibility" do
    matrix =
      Primitives.matrix(
        {6, 4, 4, 4},
        {5, 5, 7, 6},
        {4, -9, 3, -7},
        {9, 1, 7, -6}
      )

    assert Operations.invertible?(matrix)

    matrix =
      Primitives.matrix(
        {4, 2, -2, -3},
        {9, 6, 2, 6},
        {0, -5, 1, -5},
        {0, 0, 0, 0}
      )

    refute Operations.invertible?(matrix)
  end

  test "matrix inversion" do
    matrix =
      Primitives.matrix(
        {-5, 2, 6, -8},
        {1, -5, 1, 8},
        {7, 7, -6, -7},
        {1, -3, 7, 4}
      )

    determinant = Operations.determinant(matrix)
    assert close_to(determinant, 532)
    cofactor = Operations.cofactor(matrix, {2, 3})
    assert close_to(cofactor, -160)
    cofactor = Operations.cofactor(matrix, {3, 2})
    assert close_to(cofactor, 105)
    inverse = Operations.inverse(matrix)
    element = element(inverse, {3, 2})
    assert close_to(element, -160 / 532)
    element = element(inverse, {2, 3})
    assert close_to(element, 105 / 532)

    assert close_to(
             inverse,
             Primitives.matrix(
               {0.21805, 0.45113, 0.24060, -0.04511},
               {-0.80827, -1.45677, -0.44361, 0.52068},
               {-0.07895, -0.22368, -0.05263, 0.19737},
               {-0.52256, -0.81391, -0.30075, 0.30639}
             )
           )

    matrix =
      Primitives.matrix(
        {8, -5, 9, 2},
        {7, 5, 6, 1},
        {-6, 0, 9, 6},
        {-3, 0, -9, -4}
      )

    inverse = Operations.inverse(matrix)

    assert close_to(
             inverse,
             Primitives.matrix(
               {-0.15385, -0.15385, -0.28205, -0.53846},
               {-0.07692, 0.12308, 0.02564, 0.03077},
               {0.35897, 0.35897, 0.43590, 0.92308},
               {-0.69231, -0.69231, -0.76923, -1.92308}
             )
           )

    matrix =
      Primitives.matrix(
        {9, 3, 0, 9},
        {-5, -2, -6, -3},
        {-4, 9, 6, 4},
        {-7, 6, 6, 2}
      )

    inverse = Operations.inverse(matrix)

    assert close_to(
             inverse,
             Primitives.matrix(
               {-0.04074, -0.07778, 0.14444, -0.22222},
               {-0.07778, 0.03333, 0.36667, -0.33333},
               {-0.02901, -0.14630, -0.10926, 0.12963},
               {0.17778, 0.06667, -0.26667, 0.33333}
             )
           )

    matrix1 =
      Primitives.matrix(
        {3, -9, 7, 3},
        {3, -8, 2, -9},
        {-4, 4, 4, 1},
        {-6, 5, -1, 1}
      )

    matrix2 =
      Primitives.matrix(
        {8, 2, 2, 2},
        {3, -1, 7, 0},
        {7, 0, 5, 4},
        {6, -2, 0, 5}
      )

    product = Operations.multiply(matrix1, matrix2)

    assert close_to(
             Operations.multiply(product, Operations.inverse(matrix2)),
             matrix1
           )
  end

  def element(matrix, {row, column}), do: matrix |> elem(row) |> elem(column)
end
