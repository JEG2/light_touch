defmodule LightTouch.TestSupport.Comparisons do
  def close_to(left, right) when is_number(left) and is_number(right) do
    abs(left - right) < 0.00001
  end

  def close_to(left, right) when is_tuple(left) and is_tuple(right) do
    tuple_size(left) == tuple_size(right) and
      Enum.all?(0..(tuple_size(left) - 1), fn i ->
        close_to(elem(left, i), elem(right, i))
      end)
  end
end
