defmodule LightTouch.CanvasTest do
  use ExUnit.Case, async: true

  import LightTouch.TestSupport.Comparisons
  alias LightTouch.{Canvas, Primitives, Operations}

  describe "colors" do
    test "color creation" do
      color = Primitives.color(-0.5, 0.4, 1.7)
      assert close_to(color, {-0.5, 0.4, 1.7})
    end

    test "adding colors" do
      color1 = Primitives.color(0.9, 0.6, 0.75)
      color2 = Primitives.color(0.7, 0.1, 0.25)
      sum = Operations.add(color1, color2)
      assert close_to(sum, Primitives.color(1.6, 0.7, 1.0))
    end

    test "subtracting colors" do
      color1 = Primitives.color(0.9, 0.6, 0.75)
      color2 = Primitives.color(0.7, 0.1, 0.25)
      difference = Operations.subtract(color1, color2)
      assert close_to(difference, Primitives.color(0.2, 0.5, 0.5))
    end

    test "multiplying colors" do
      color = Primitives.color(0.2, 0.3, 0.4)
      product = Operations.multiply(color, 2)
      assert close_to(product, Primitives.color(0.4, 0.6, 0.8))

      color1 = Primitives.color(1, 0.2, 0.4)
      color2 = Primitives.color(0.9, 1, 0.1)
      product = Operations.multiply(color1, color2)
      assert close_to(product, Primitives.color(0.9, 0.2, 0.04))
    end
  end

  describe "canvas" do
    test "has a width and height" do
      width = 20
      height = 10
      canvas = Canvas.new(width, height)
      assert canvas.width == width
      assert canvas.height == height
    end

    test "defaults pixels to black" do
      canvas = Canvas.new(20, 10)
      black = Primitives.color(0, 0, 0)

      Enum.each(0..9, fn y ->
        Enum.each(0..19, fn x ->
          drawn = Canvas.view(canvas, {x, y})
          assert close_to(drawn, black)
        end)
      end)
    end

    test "supports drawing pixels" do
      red = Primitives.color(1, 0, 0)
      canvas = Canvas.new(20, 10) |> Canvas.draw({2, 3}, red)
      drawn = Canvas.view(canvas, {2, 3})

      assert close_to(drawn, red)
    end

    test "colors are constrained on conversion" do
      color = Primitives.color(-0.5, 0.4, 1.7)
      converted = Canvas.Utils.color_to_bytes(color)
      assert close_to(converted, {0, 102, 255})
    end

    test "writes PNG files" do
      canvas =
        Canvas.new(5, 3)
        |> Canvas.draw({0, 0}, Primitives.color(1.5, 0, 0))
        |> Canvas.draw({2, 1}, Primitives.color(0, 0.5, 0))
        |> Canvas.draw({4, 2}, Primitives.color(-0.5, 0, 1))

      path = "test.png"

      File.cd!(System.tmp_dir!(), fn ->
        if File.exists?(path), do: File.rm(path)

        assert !File.exists?(path)
        Canvas.to_png(canvas, path)
        assert File.exists?(path)

        File.rm(path)
      end)
    end
  end
end
