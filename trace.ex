alias LightTouch.{Primitives, Canvas, Object, Ray, Operations, Intersection}

ray_origin = Primitives.point(0, 0, -5)
wall_z = 10
wall_size = 7
canvas_pixels = 100
pixel_size = wall_size / canvas_pixels
half = wall_size / 2
canvas = Canvas.new(canvas_pixels, canvas_pixels)
color = Primitives.color(1, 0, 0)

shape =
  Object.sphere()
  |> Object.transform(scale_x: 0.5, shear: [1, 0, 0, 0, 0, 0])

Enum.reduce(0..(canvas_pixels - 1), canvas, fn y, canvas ->
  world_y = half - pixel_size * y

  Enum.reduce(0..(canvas_pixels - 1), canvas, fn x, canvas ->
    world_x = -half + pixel_size * x
    position = Primitives.point(world_x, world_y, wall_z)

    r =
      Ray.new(
        ray_origin,
        Operations.normalize(Operations.subtract(position, ray_origin))
      )

    xs = Ray.intersect(r, shape)

    case Intersection.find_hit(xs) do
      hit when not is_nil(hit) ->
        Canvas.draw(canvas, {x, y}, color)

      nil ->
        canvas
    end
  end)
end)
|> Canvas.to_png("trace.png")
