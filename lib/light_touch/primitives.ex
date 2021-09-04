defmodule LightTouch.Primitives do
  defguard is_point(term)
           when is_tuple(term) and tuple_size(term) == 4 and elem(term, 3) == 1

  defguard is_vector(term)
           when is_tuple(term) and tuple_size(term) == 4 and elem(term, 3) == 0

  def color(red, green, blue), do: {red, green, blue}

  def point(x, y, z), do: {x, y, z, 1}

  def vector(x, y, z), do: {x, y, z, 0}
end
