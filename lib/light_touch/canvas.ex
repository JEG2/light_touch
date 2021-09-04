defmodule LightTouch.Canvas do
  defmodule Utils do
    def color_to_bytes({r, g, b}) do
      {to_byte(r * 255), to_byte(g * 255), to_byte(b * 255)}
    end

    defp to_byte(f) when is_float(f), do: f |> round() |> to_byte()
    defp to_byte(i) when is_integer(i) and i < 0, do: 0
    defp to_byte(i) when is_integer(i) and i > 255, do: 255
    defp to_byte(i) when is_integer(i), do: i
  end

  defstruct width: nil,
            height: nil,
            pixels: Map.new(),
            default_color: LightTouch.Primitives.color(0, 0, 0)

  def new({width, height})
      when is_integer(width) and width > 0 and
             is_integer(height) and height > 0 do
    %__MODULE__{width: width, height: height}
  end

  def view(%__MODULE__{width: width, height: height} = canvas, {x, y} = xy)
      when is_integer(x) and x >= 0 and x < width and
             is_integer(y) and y >= 0 and y < height do
    Map.get(canvas.pixels, xy, canvas.default_color)
  end

  def draw(
        %__MODULE__{width: width, height: height} = canvas,
        {x, y} = xy,
        color
      )
      when is_integer(x) and x >= 0 and x < width and
             is_integer(y) and y >= 0 and y < height do
    %__MODULE__{canvas | pixels: Map.put(canvas.pixels, xy, color)}
  end

  def to_png(canvas, path) do
    image = :egd.create(canvas.width, canvas.height)

    Enum.reduce(0..(canvas.height - 1), %{}, fn y, color_map ->
      Enum.reduce(0..(canvas.width - 1), color_map, fn x, color_map ->
        xy = {x, y}
        color = view(canvas, xy)

        color_map =
          Map.put_new_lazy(color_map, color, fn ->
            color
            |> Utils.color_to_bytes()
            |> :egd.color()
          end)

        color_ref = Map.fetch!(color_map, color)
        :ok = :egd.line(image, xy, xy, color_ref)
        color_map
      end)
    end)

    image
    |> :egd.render()
    |> :egd.save(String.to_charlist(path))
  end
end
