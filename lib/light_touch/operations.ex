defmodule LightTouch.Operations do
  def add({lr, lg, lb}, {rr, rg, rb}), do: {lr + rr, lg + rg, lb + rb}

  def add({lx, ly, lz, lw}, {rx, ry, rz, rw})
      when lw in [0, 1] and rw in [0, 1] and lw + rw != 2 do
    {lx + rx, ly + ry, lz + rz, lw + rw}
  end

  def cross_product({lx, ly, lz, 0}, {rx, ry, rz, 0}) do
    {ly * rz - lz * ry, lz * rx - lx * rz, lx * ry - ly * rx, 0.0}
  end

  def divide({x, y, z, 0}, n) when is_number(n), do: {x / n, y / n, z / n, 0}

  def dot_product({lx, ly, lz, 0}, {rx, ry, rz, 0}) do
    lx * rx + ly * ry + lz * rz
  end

  def magnitude({x, y, z, 0}) do
    :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2) + :math.pow(z, 2))
  end

  def multiply({r, g, b}, n) when is_number(n), do: {r * n, g * n, b * n}

  def multiply({x, y, z, 0}, n) when is_number(n), do: {x * n, y * n, z * n, 0}

  def multiply({lr, lg, lb}, {rr, rg, rb}), do: {lr * rr, lg * rg, lb * rb}

  def negate({x, y, z, 0}), do: {-x, -y, -z, 0}

  def normalize({x, y, z, 0} = vector) do
    m = magnitude(vector)
    {x / m, y / m, z / m, 0}
  end

  def subtract({lr, lg, lb}, {rr, rg, rb}), do: {lr - rr, lg - rg, lb - rb}

  def subtract({lx, ly, lz, lw}, {rx, ry, rz, rw})
      when lw in [0, 1] and rw in [0, 1] and lw + rw != -1 do
    {lx - rx, ly - ry, lz - rz, lw - rw}
  end
end
