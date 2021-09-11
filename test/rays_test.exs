defmodule LightTouch.RaysTest do
  use ExUnit.Case, async: true

  import LightTouch.TestSupport.Comparisons
  alias LightTouch.{Primitives, Transformations, Ray, Object, Intersection}

  describe "rays" do
    test "creating rays" do
      ray = Ray.new({1, 2, 3}, {4, 5, 6})
      assert close_to(ray.origin, Primitives.point(1, 2, 3))
      assert close_to(ray.direction, Primitives.vector(4, 5, 6))
    end

    test "computing points from a distance" do
      ray = Ray.new({2, 3, 4}, {1, 0, 0})
      point = Ray.position(ray, 0)
      assert close_to(point, Primitives.point(2, 3, 4))
      point = Ray.position(ray, 1)
      assert close_to(point, Primitives.point(3, 3, 4))
      point = Ray.position(ray, -1)
      assert close_to(point, Primitives.point(1, 3, 4))
      point = Ray.position(ray, 2.5)
      assert close_to(point, Primitives.point(4.5, 3, 4))
    end
  end

  describe "intersection" do
    test "creating intersections" do
      sphere = Object.sphere()
      intersection = Intersection.new(3.5, sphere)
      assert close_to(intersection.t, 3.5)
      assert intersection.object == sphere
    end

    test "aggregating intersections" do
      sphere = Object.sphere()
      intersection1 = Intersection.new(1, sphere)
      intersection2 = Intersection.new(2, sphere)
      intersections = [intersection1, intersection2]
      assert close_to(Enum.at(intersections, 0).t, 1)
      assert close_to(Enum.at(intersections, 1).t, 2)
    end

    test "a ray passes through a sphere" do
      ray = Ray.new({0, 0, -5}, {0, 0, 1})
      sphere = Object.sphere()
      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 2
      assert close_to(Enum.at(intersections, 0).t, 4.0)
      assert close_to(Enum.at(intersections, 1).t, 6.0)
    end

    test "a ray touches a sphere on a tangent" do
      ray = Ray.new({0, 1, -5}, {0, 0, 1})
      sphere = Object.sphere()
      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 2
      assert close_to(Enum.at(intersections, 0).t, 5.0)
      assert close_to(Enum.at(intersections, 1).t, 5.0)
    end

    test "a ray misses a sphere" do
      ray = Ray.new({0, 2, -5}, {0, 0, 1})
      sphere = Object.sphere()
      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 0
    end

    test "a ray inside a sphere" do
      ray = Ray.new({0, 0, 0}, {0, 0, 1})
      sphere = Object.sphere()
      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 2
      assert close_to(Enum.at(intersections, 0).t, -1.0)
      assert close_to(Enum.at(intersections, 1).t, 1.0)
    end

    test "a ray in front of a sphere" do
      ray = Ray.new({0, 0, 5}, {0, 0, 1})
      sphere = Object.sphere()
      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 2
      assert close_to(Enum.at(intersections, 0).t, -6.0)
      assert close_to(Enum.at(intersections, 1).t, -4.0)
    end
  end

  describe "hits" do
    test "all intersections have positive t" do
      sphere = Object.sphere()
      intersection1 = Intersection.new(1, sphere)
      intersection2 = Intersection.new(2, sphere)
      hit = Intersection.find_hit([intersection1, intersection2])
      assert close_to(intersection1.t, hit.t)
    end

    test "some intersections have negative t" do
      sphere = Object.sphere()
      intersection1 = Intersection.new(-1, sphere)
      intersection2 = Intersection.new(1, sphere)
      hit = Intersection.find_hit([intersection1, intersection2])
      assert close_to(intersection2.t, hit.t)
    end

    test "all intersections have negative t" do
      sphere = Object.sphere()
      intersection1 = Intersection.new(-2, sphere)
      intersection2 = Intersection.new(-1, sphere)
      hit = Intersection.find_hit([intersection1, intersection2])
      assert is_nil(hit)
    end

    test "the hit is always the lowest non-negative t" do
      sphere = Object.sphere()
      intersection1 = Intersection.new(5, sphere)
      intersection2 = Intersection.new(7, sphere)
      intersection3 = Intersection.new(-3, sphere)
      intersection4 = Intersection.new(2, sphere)

      hit =
        Intersection.find_hit([
          intersection1,
          intersection2,
          intersection3,
          intersection4
        ])

      assert close_to(intersection4.t, hit.t)
    end
  end

  describe "transformations" do
    test "translating rays" do
      ray = Ray.new({1, 2, 3}, {0, 1, 0})
      translation = Transformations.translate(3, 4, 5)
      translated = Ray.transform(ray, translation)
      assert close_to(translated.origin, Primitives.point(4, 6, 8))
      assert close_to(translated.direction, Primitives.vector(0, 1, 0))
    end

    test "scaling rays" do
      ray = Ray.new({1, 2, 3}, {0, 1, 0})
      scale = Transformations.scale(2, 3, 4)
      scaled = Ray.transform(ray, scale)
      assert close_to(scaled.origin, Primitives.point(2, 6, 12))
      assert close_to(scaled.direction, Primitives.vector(0, 3, 0))
    end

    test "an object's default transformation" do
      sphere = Object.sphere()
      assert close_to(sphere.transformation, Primitives.identity_matrix())
    end

    test "changing an object's transformation" do
      sphere =
        Object.sphere()
        |> Object.transform(translate: [2, 3, 4])

      assert close_to(sphere.transformation, Transformations.translate(2, 3, 4))
    end

    test "intersecting a scaled sphere" do
      ray = Ray.new({0, 0, -5}, {0, 0, 1})

      sphere =
        Object.sphere()
        |> Object.transform(scale: [2, 2, 2])

      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 2
      assert close_to(Enum.at(intersections, 0).t, 3)
      assert close_to(Enum.at(intersections, 1).t, 7)
    end

    test "intersecting a translated sphere" do
      ray = Ray.new({0, 0, -5}, {0, 0, 1})

      sphere =
        Object.sphere()
        |> Object.transform(translate: [5, 0, 0])

      intersections = Ray.intersect(ray, sphere)
      assert length(intersections) == 0
    end
  end
end
