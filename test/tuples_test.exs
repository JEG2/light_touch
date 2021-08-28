defmodule LightTouch.TuplesTest do
  use ExUnit.Case

  require LightTouch.Primitives
  alias LightTouch.{Primitives, Operations}

  test "recognizing points and vectors" do
    point = {4.3, -4.2, 3.1, 1.0}
    assert Primitives.is_point(point)
    refute Primitives.is_vector(point)

    vector = {4.3, -4.2, 3.1, 0.0}
    assert Primitives.is_vector(vector)
    refute Primitives.is_point(vector)
  end

  test "point and vector creation" do
    point = Primitives.point(4, -4, 3)
    assert close_to(point, {4, -4, 3, 1})

    vector = Primitives.vector(4, -4, 3)
    assert close_to(vector, {4, -4, 3, 0})
  end

  test "adding tuples" do
    point = Primitives.point(3, -2, 5)
    vector = Primitives.vector(-2, 3, 1)
    sum = Operations.add(point, vector)
    assert close_to(sum, Primitives.point(1, 1, 6))
  end

  test "subtracting tuples" do
    point1 = Primitives.point(3, 2, 1)
    point2 = Primitives.point(5, 6, 7)
    difference = Operations.subtract(point1, point2)
    assert close_to(difference, Primitives.vector(-2, -4, -6))

    vector2 = Primitives.vector(5, 6, 7)
    difference = Operations.subtract(point1, vector2)
    assert close_to(difference, Primitives.point(-2, -4, -6))

    vector1 = Primitives.vector(3, 2, 1)
    difference = Operations.subtract(vector1, vector2)
    assert close_to(difference, Primitives.vector(-2, -4, -6))
  end

  test "negating vectors" do
    zero = Primitives.vector(0, 0, 0)
    vector = Primitives.vector(1, -2, 3)
    negated = Operations.subtract(zero, vector)
    assert close_to(negated, Primitives.vector(-1, 2, -3))

    negated = Operations.negate(vector)
    assert close_to(negated, Primitives.vector(-1, 2, -3))
  end

  test "multiplying vectors" do
    vector = Primitives.vector(1, -2, 3)
    product = Operations.multiply(vector, 3.5)
    assert close_to(product, Primitives.vector(3.5, -7, 10.5))

    product = Operations.multiply(vector, 0.5)
    assert close_to(product, Primitives.vector(0.5, -1, 1.5))
  end

  test "dividing vectors" do
    vector = Primitives.vector(1, -2, 3)
    product = Operations.divide(vector, 2)
    assert close_to(product, Primitives.vector(0.5, -1, 1.5))
  end

  test "calculating the magnitude of vectors" do
    vector = Primitives.vector(1, 0, 0)
    magnitude = Operations.magnitude(vector)
    assert close_to(magnitude, 1)

    vector = Primitives.vector(0, 1, 0)
    magnitude = Operations.magnitude(vector)
    assert close_to(magnitude, 1)

    vector = Primitives.vector(0, 0, 1)
    magnitude = Operations.magnitude(vector)
    assert close_to(magnitude, 1)

    vector = Primitives.vector(1, 2, 3)
    magnitude = Operations.magnitude(vector)
    assert close_to(magnitude, :math.sqrt(14))

    vector = Primitives.vector(-1, -2, -3)
    magnitude = Operations.magnitude(vector)
    assert close_to(magnitude, :math.sqrt(14))
  end

  test "normalizing vectors" do
    vector = Primitives.vector(4, 0, 0)
    normalized = Operations.normalize(vector)
    assert close_to(normalized, Primitives.vector(1, 0, 0))

    vector = Primitives.vector(1, 2, 3)
    normalized = Operations.normalize(vector)
    r = :math.sqrt(14)
    assert close_to(normalized, Primitives.vector(1 / r, 2 / r, 3 / r))

    magnitude = Operations.magnitude(normalized)
    assert close_to(magnitude, 1)
  end

  test "calculating the dot product of vectors" do
    vector1 = Primitives.vector(1, 2, 3)
    vector2 = Primitives.vector(2, 3, 4)
    product = Operations.dot_product(vector1, vector2)
    assert close_to(product, 20)
  end

  test "calculating the cross product of vectors" do
    vector1 = Primitives.vector(1, 2, 3)
    vector2 = Primitives.vector(2, 3, 4)
    product = Operations.cross_product(vector1, vector2)
    assert close_to(product, Primitives.vector(-1, 2, -1))

    product = Operations.cross_product(vector2, vector1)
    assert close_to(product, Primitives.vector(1, -2, 1))
  end

  defp close_to(left, right) when is_number(left) and is_number(right) do
    abs(left - right) < 0.00001
  end

  defp close_to(left, right) when is_tuple(left) and is_tuple(right) do
    tuple_size(left) == tuple_size(right) and
      Enum.all?(0..(tuple_size(left) - 1), fn i ->
        close_to(elem(left, i), elem(right, i))
      end)
  end
end
