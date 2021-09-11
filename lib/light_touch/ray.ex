defmodule LightTouch.Ray do
  alias LightTouch.{Primitives, Operations, Object, Intersection}

  @enforce_keys ~w[origin direction]a
  defstruct ~w[origin direction]a

  def new({ox, oy, oz}, direction) do
    new(Primitives.point(ox, oy, oz), direction)
  end

  def new(origin, {dx, dy, dz}) do
    new(origin, Primitives.vector(dx, dy, dz))
  end

  def new({_ox, _oy, _oz, ow} = origin, {_dx, _dy, _dz, dw} = direction)
      when ow == 1 and dw == 0 do
    %__MODULE__{
      origin: origin,
      direction: direction
    }
  end

  def intersect(%__MODULE__{} = ray, %Object{shape: :sphere} = sphere) do
    transformed = transform(ray, Operations.inverse(sphere.transformation))

    sphere_to_ray =
      Operations.subtract(
        transformed.origin,
        Primitives.point(0, 0, 0)
      )

    a = Operations.dot_product(transformed.direction, transformed.direction)
    b = 2 * Operations.dot_product(transformed.direction, sphere_to_ray)
    c = Operations.dot_product(sphere_to_ray, sphere_to_ray) - 1

    case :math.pow(b, 2) - 4 * a * c do
      discriminant when discriminant >= 0 ->
        root = :math.sqrt(discriminant)

        [
          Intersection.new((-b - root) / (2 * a), sphere),
          Intersection.new((-b + root) / (2 * a), sphere)
        ]

      _negative ->
        []
    end
  end

  def position(%__MODULE__{} = ray, t) do
    Operations.add(ray.origin, Operations.multiply(ray.direction, t))
  end

  def transform(%__MODULE__{} = ray, transformation) do
    %__MODULE__{
      origin: Operations.multiply(transformation, ray.origin),
      direction: Operations.multiply(transformation, ray.direction)
    }
  end
end
