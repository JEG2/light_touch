defmodule LightTouch.Transformations do
  alias LightTouch.{Primitives, Operations}

  def rotate_x(degrees) do
    radians = degrees_to_radians(degrees)

    {
      {1, 0, 0, 0},
      {0, :math.cos(radians), -:math.sin(radians), 0},
      {0, :math.sin(radians), :math.cos(radians), 0},
      {0, 0, 0, 1}
    }
  end

  def rotate_y(degrees) do
    radians = degrees_to_radians(degrees)

    {
      {:math.cos(radians), 0, :math.sin(radians), 0},
      {0, 1, 0, 0},
      {-:math.sin(radians), 0, :math.cos(radians), 0},
      {0, 0, 0, 1}
    }
  end

  def rotate_z(degrees) do
    radians = degrees_to_radians(degrees)

    {
      {:math.cos(radians), -:math.sin(radians), 0, 0},
      {:math.sin(radians), :math.cos(radians), 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
    }
  end

  def scale(x, y, z) do
    {
      {x, 0, 0, 0},
      {0, y, 0, 0},
      {0, 0, z, 0},
      {0, 0, 0, 1}
    }
  end

  def scale_x(x), do: scale(x, 1, 1)

  def scale_y(y), do: scale(1, y, 1)

  def scale_z(z), do: scale(1, 1, z)

  def shear(xy, xz, yx, yz, zx, zy) do
    {
      {1, xy, xz, 0},
      {yx, 1, yz, 0},
      {zx, zy, 1, 0},
      {0, 0, 0, 1}
    }
  end

  def combine(initial \\ Primitives.identity_matrix(), transformations) do
    Enum.reduce(
      transformations,
      initial,
      fn {f, args}, combined ->
        __MODULE__
        |> apply(f, List.wrap(args))
        |> Operations.multiply(combined)
      end
    )
  end

  def translate(x, y, z) do
    {
      {1, 0, 0, x},
      {0, 1, 0, y},
      {0, 0, 1, z},
      {0, 0, 0, 1}
    }
  end

  def translate_x(x), do: translate(x, 0, 0)

  def translate_y(y), do: translate(0, y, 0)

  def translate_z(z), do: translate(0, 0, z)

  defp degrees_to_radians(degrees), do: degrees / 180 * :math.pi()
end
