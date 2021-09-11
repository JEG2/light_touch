defmodule LightTouch.Intersection do
  @enforce_keys ~w[t object]a
  defstruct ~w[t object]a

  def new(t, object), do: %__MODULE__{t: t, object: object}

  def find_hit(intersections) do
    intersections
    |> Enum.reject(fn intersection -> intersection.t < 0 end)
    |> Enum.min_by(fn intersection -> intersection.t end, &<=/2, fn -> nil end)
  end
end
