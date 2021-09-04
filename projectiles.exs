alias LightTouch.{Canvas, Operations, Primitives}

start = Primitives.point(0, 1, 0)

velocity =
  Primitives.vector(1, 1.8, 0)
  |> Operations.normalize()
  |> Operations.multiply(11.25)

gravity = Primitives.vector(0, -0.1, 0)
wind = Primitives.vector(-0.01, 0, 0)
env = %{gravity: gravity, wind: wind}

red = Primitives.color(1, 0, 0)

%{position: start, velocity: velocity}
|> Stream.iterate(fn projectile ->
  position = Operations.add(projectile.position, projectile.velocity)

  velocity =
    projectile.velocity
    |> Operations.add(env.gravity)
    |> Operations.add(env.wind)

  %{position: position, velocity: velocity}
end)
|> Stream.take_while(fn
  %{position: {_x, y, _z, 1}} when y > 0 -> true
  _projectile -> false
end)
|> Enum.reduce(Canvas.new({900, 550}), fn %{position: {x, y, _z, 1}}, canvas ->
  Canvas.draw(canvas, {round(x), round(canvas.height - y)}, red)
end)
|> Canvas.to_png("projectile.png")
