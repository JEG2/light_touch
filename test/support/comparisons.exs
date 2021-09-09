defmodule LightTouch.TestSupport.Comparisons do
  def close_to(left, right)
      when is_tuple(left) and is_tuple(right) and
             left |> elem(0) |> is_tuple() do
    tuple_size(left) == tuple_size(right) and
      Enum.all?(0..(tuple_size(left) - 1), fn row ->
        left_row = elem(left, row)
        right_row = elem(right, row)
        close_to(left_row, right_row)
      end)
  end

  def close_to(left, right) when is_tuple(left) and is_tuple(right) do
    tuple_size(left) == tuple_size(right) and
      Enum.all?(0..(tuple_size(left) - 1), fn i ->
        close_to(elem(left, i), elem(right, i))
      end)
  end

  def close_to(left, right) when is_number(left) and is_number(right) do
    abs(left - right) < 0.00001
  end
end
