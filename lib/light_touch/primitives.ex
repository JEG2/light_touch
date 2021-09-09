defmodule LightTouch.Primitives do
  defguard is_point(term)
           when is_tuple(term) and tuple_size(term) == 4 and elem(term, 3) == 1

  defguard is_vector(term)
           when is_tuple(term) and tuple_size(term) == 4 and elem(term, 3) == 0

  def color(red, green, blue), do: {red, green, blue}

  def identity_matrix do
    {
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
    }
  end

  def matrix(
        {_r0c0, _r0c1} = r0,
        {_r1c0, _r1c1} = r1
      ) do
    {
      r0,
      r1
    }
  end

  def matrix(
        {_r0c0, _r0c1, _r0c2} = r0,
        {_r1c0, _r1c1, _r1c2} = r1,
        {_r2c0, _r2c1, _r2c2} = r2
      ) do
    {
      r0,
      r1,
      r2
    }
  end

  def matrix(
        {_r0c0, _r0c1, _r0c2, _r0c3} = r0,
        {_r1c0, _r1c1, _r1c2, _r1c3} = r1,
        {_r2c0, _r2c1, _r2c2, _r2c3} = r2,
        {_r3c0, _r3c1, _r3c2, _r3c3} = r3
      ) do
    {
      r0,
      r1,
      r2,
      r3
    }
  end

  def point(x, y, z), do: {x, y, z, 1}

  def vector(x, y, z), do: {x, y, z, 0}
end
