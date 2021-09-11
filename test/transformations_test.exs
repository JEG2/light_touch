defmodule LightTouch.TransformationsTest do
  use ExUnit.Case, async: true

  import LightTouch.TestSupport.Comparisons
  alias LightTouch.{Primitives, Operations, Transformations}

  describe "translation" do
    test "points" do
      translation = Transformations.translate(5, -3, 2)
      point = Primitives.point(-3, 4, 5)
      translated = Operations.multiply(translation, point)
      assert close_to(translated, Primitives.point(2, 1, 7))
    end

    test "inverse" do
      translation =
        Transformations.translate(5, -3, 2)
        |> Operations.inverse()

      point = Primitives.point(-3, 4, 5)
      translated = Operations.multiply(translation, point)
      assert close_to(translated, Primitives.point(-8, 7, 3))
    end

    test "vectors" do
      translation = Transformations.translate(5, -3, 2)
      vector = Primitives.vector(-3, 4, 5)
      translated = Operations.multiply(translation, vector)
      assert close_to(translated, vector)
    end
  end

  describe "scaling" do
    test "points" do
      scale = Transformations.scale(2, 3, 4)
      point = Primitives.point(-4, 6, 8)
      scaled = Operations.multiply(scale, point)
      assert close_to(scaled, Primitives.point(-8, 18, 32))
    end

    test "vectors" do
      scale = Transformations.scale(2, 3, 4)
      vector = Primitives.vector(-4, 6, 8)
      scaled = Operations.multiply(scale, vector)
      assert close_to(scaled, Primitives.vector(-8, 18, 32))
    end

    test "inverse" do
      scale =
        Transformations.scale(2, 3, 4)
        |> Operations.inverse()

      vector = Primitives.vector(-4, 6, 8)
      scaled = Operations.multiply(scale, vector)
      assert close_to(scaled, Primitives.vector(-2, 2, 2))
    end

    test "reflection" do
      scale = Transformations.scale_x(-1)
      point = Primitives.point(2, 3, 4)
      scaled = Operations.multiply(scale, point)
      assert close_to(scaled, Primitives.point(-2, 3, 4))
    end
  end

  describe "rotation" do
    test "points around the x axis" do
      point = Primitives.point(0, 1, 0)
      rotation = Transformations.rotate_x(45)
      rotated = Operations.multiply(rotation, point)
      root = :math.sqrt(2)
      assert close_to(rotated, Primitives.point(0, root / 2, root / 2))

      rotation = Transformations.rotate_x(90)
      rotated = Operations.multiply(rotation, point)
      assert close_to(rotated, Primitives.point(0, 0, 1))
    end

    test "inverse around the x axis" do
      point = Primitives.point(0, 1, 0)

      rotation =
        Transformations.rotate_x(45)
        |> Operations.inverse()

      rotated = Operations.multiply(rotation, point)
      root = :math.sqrt(2)
      assert close_to(rotated, Primitives.point(0, root / 2, -root / 2))
    end

    test "points around the y axis" do
      point = Primitives.point(0, 0, 1)
      rotation = Transformations.rotate_y(45)
      rotated = Operations.multiply(rotation, point)
      root = :math.sqrt(2)
      assert close_to(rotated, Primitives.point(root / 2, 0, root / 2))

      rotation = Transformations.rotate_y(90)
      rotated = Operations.multiply(rotation, point)
      assert close_to(rotated, Primitives.point(1, 0, 0))
    end

    test "points around the z axis" do
      point = Primitives.point(0, 1, 0)
      rotation = Transformations.rotate_z(45)
      rotated = Operations.multiply(rotation, point)
      root = :math.sqrt(2)
      assert close_to(rotated, Primitives.point(-root / 2, root / 2, 0))

      rotation = Transformations.rotate_z(90)
      rotated = Operations.multiply(rotation, point)
      assert close_to(rotated, Primitives.point(-1, 0, 0))
    end
  end

  describe "shearing" do
    test "x in proportion to y" do
      shear = Transformations.shear(1, 0, 0, 0, 0, 0)
      point = Primitives.point(2, 3, 4)
      sheared = Operations.multiply(shear, point)
      assert close_to(sheared, Primitives.point(5, 3, 4))
    end

    test "x in proportion to z" do
      shear = Transformations.shear(0, 1, 0, 0, 0, 0)
      point = Primitives.point(2, 3, 4)
      sheared = Operations.multiply(shear, point)
      assert close_to(sheared, Primitives.point(6, 3, 4))
    end

    test "y in proportion to x" do
      shear = Transformations.shear(0, 0, 1, 0, 0, 0)
      point = Primitives.point(2, 3, 4)
      sheared = Operations.multiply(shear, point)
      assert close_to(sheared, Primitives.point(2, 5, 4))
    end

    test "y in proportion to z" do
      shear = Transformations.shear(0, 0, 0, 1, 0, 0)
      point = Primitives.point(2, 3, 4)
      sheared = Operations.multiply(shear, point)
      assert close_to(sheared, Primitives.point(2, 7, 4))
    end

    test "z in proportion to x" do
      shear = Transformations.shear(0, 0, 0, 0, 1, 0)
      point = Primitives.point(2, 3, 4)
      sheared = Operations.multiply(shear, point)
      assert close_to(sheared, Primitives.point(2, 3, 6))
    end

    test "z in proportion to y" do
      shear = Transformations.shear(0, 0, 0, 0, 0, 1)
      point = Primitives.point(2, 3, 4)
      sheared = Operations.multiply(shear, point)
      assert close_to(sheared, Primitives.point(2, 3, 7))
    end
  end

  describe "chaining" do
    test "applied in reverse order" do
      point = Primitives.point(1, 0, 1)
      rotation = Transformations.rotate_x(90)
      rotated = Operations.multiply(rotation, point)
      assert close_to(rotated, Primitives.point(1, -1, 0))

      scale = Transformations.scale(5, 5, 5)
      scaled = Operations.multiply(scale, rotated)
      assert close_to(scaled, Primitives.point(5, -5, 0))

      translation = Transformations.translate(10, 5, 7)
      translated = Operations.multiply(translation, scaled)
      assert close_to(translated, Primitives.point(15, 0, 7))

      transformation =
        Transformations.combine(
          rotate_x: 90,
          scale: [5, 5, 5],
          translate: [10, 5, 7]
        )

      transformed = Operations.multiply(transformation, point)
      assert close_to(transformed, Primitives.point(15, 0, 7))
    end
  end
end
