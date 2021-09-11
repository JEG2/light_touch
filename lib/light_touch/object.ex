defmodule LightTouch.Object do
  alias LightTouch.{Primitives, Transformations}

  @enforce_keys ~w[shape]a
  defstruct shape: nil, transformation: Primitives.identity_matrix()

  def sphere(), do: %__MODULE__{shape: :sphere}

  def transform(%__MODULE__{} = object, transformations) do
    %__MODULE__{
      object
      | transformation:
          Transformations.combine(
            object.transformation,
            transformations
          )
    }
  end
end
