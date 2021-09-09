defmodule LightTouch.Operations do
  require Integer

  def add({lr, lg, lb}, {rr, rg, rb}), do: {lr + rr, lg + rg, lb + rb}

  def add({lx, ly, lz, lw}, {rx, ry, rz, rw})
      when lw in [0, 1] and rw in [0, 1] and lw + rw != 2 do
    {lx + rx, ly + ry, lz + rz, lw + rw}
  end

  def cofactor(
        {
          {_r0c0, _r0c1, _r0c2},
          {_r1c0, _r1c1, _r1c2},
          {_r2c0, _r2c1, _r2c2}
        } = matrix,
        {row, column}
      )
      when Integer.is_odd(row + column) do
    -minor(matrix, {row, column})
  end

  def cofactor(
        {
          {_r0c0, _r0c1, _r0c2},
          {_r1c0, _r1c1, _r1c2},
          {_r2c0, _r2c1, _r2c2}
        } = matrix,
        row_column
      ) do
    minor(matrix, row_column)
  end

  def cofactor(
        {
          {_r0c0, _r0c1, _r0c2, _r0c3},
          {_r1c0, _r1c1, _r1c2, _r1c3},
          {_r2c0, _r2c1, _r2c2, _r2c3},
          {_r3c0, _r3c1, _r3c2, _r3c3}
        } = matrix,
        {row, column}
      )
      when Integer.is_odd(row + column) do
    -minor(matrix, {row, column})
  end

  def cofactor(
        {
          {_r0c0, _r0c1, _r0c2, _r0c3},
          {_r1c0, _r1c1, _r1c2, _r1c3},
          {_r2c0, _r2c1, _r2c2, _r2c3},
          {_r3c0, _r3c1, _r3c2, _r3c3}
        } = matrix,
        row_column
      ) do
    minor(matrix, row_column)
  end

  def cross_product({lx, ly, lz, 0}, {rx, ry, rz, 0}) do
    {ly * rz - lz * ry, lz * rx - lx * rz, lx * ry - ly * rx, 0.0}
  end

  def determinant({
        {r0c0, r0c1},
        {r1c0, r1c1}
      }) do
    r0c0 * r1c1 - r0c1 * r1c0
  end

  def determinant(
        {
          {r0c0, r0c1, r0c2},
          {_r1c0, _r1c1, _r1c2},
          {_r2c0, _r2c1, _r2c2}
        } = matrix
      ) do
    r0c0 * cofactor(matrix, {0, 0}) +
      r0c1 * cofactor(matrix, {0, 1}) +
      r0c2 * cofactor(matrix, {0, 2})
  end

  def determinant(
        {
          {r0c0, r0c1, r0c2, r0c3},
          {_r1c0, _r1c1, _r1c2, _r1c3},
          {_r2c0, _r2c1, _r2c2, _r2c3},
          {_r3c0, _r3c1, _r3c2, _r3c3}
        } = matrix
      ) do
    r0c0 * cofactor(matrix, {0, 0}) +
      r0c1 * cofactor(matrix, {0, 1}) +
      r0c2 * cofactor(matrix, {0, 2}) +
      r0c3 * cofactor(matrix, {0, 3})
  end

  def divide({x, y, z, 0}, n) when is_number(n), do: {x / n, y / n, z / n, 0}

  def dot_product({lx, ly, lz, 0}, {rx, ry, rz, 0}) do
    lx * rx + ly * ry + lz * rz
  end

  def inverse(
        {
          {_r0c0, _r0c1, _r0c2, _r0c3},
          {_r1c0, _r1c1, _r1c2, _r1c3},
          {_r2c0, _r2c1, _r2c2, _r2c3},
          {_r3c0, _r3c1, _r3c2, _r3c3}
        } = matrix
      ) do
    determinant = determinant(matrix)

    {
      {
        cofactor(matrix, {0, 0}) / determinant,
        cofactor(matrix, {1, 0}) / determinant,
        cofactor(matrix, {2, 0}) / determinant,
        cofactor(matrix, {3, 0}) / determinant
      },
      {
        cofactor(matrix, {0, 1}) / determinant,
        cofactor(matrix, {1, 1}) / determinant,
        cofactor(matrix, {2, 1}) / determinant,
        cofactor(matrix, {3, 1}) / determinant
      },
      {
        cofactor(matrix, {0, 2}) / determinant,
        cofactor(matrix, {1, 2}) / determinant,
        cofactor(matrix, {2, 2}) / determinant,
        cofactor(matrix, {3, 2}) / determinant
      },
      {
        cofactor(matrix, {0, 3}) / determinant,
        cofactor(matrix, {1, 3}) / determinant,
        cofactor(matrix, {2, 3}) / determinant,
        cofactor(matrix, {3, 3}) / determinant
      }
    }
  end

  def invertible?(matrix)
      when is_tuple(matrix) and matrix |> elem(0) |> is_tuple() do
    determinant(matrix) != 0
  end

  def magnitude({x, y, z, 0}) do
    :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2) + :math.pow(z, 2))
  end

  def minor(
        {
          {_r0c0, _r0c1, _r0c2},
          {_r1c0, _r1c1, _r1c2},
          {_r2c0, _r2c1, _r2c2}
        } = matrix,
        row_column
      ) do
    matrix
    |> submatrix(row_column)
    |> determinant()
  end

  def minor(
        {
          {_r0c0, _r0c1, _r0c2, _r0c3},
          {_r1c0, _r1c1, _r1c2, _r1c3},
          {_r2c0, _r2c1, _r2c2, _r2c3},
          {_r3c0, _r3c1, _r3c2, _r3c3}
        } = matrix,
        row_column
      ) do
    matrix
    |> submatrix(row_column)
    |> determinant()
  end

  def multiply(
        {
          {lr0c0, lr0c1, lr0c2, lr0c3},
          {lr1c0, lr1c1, lr1c2, lr1c3},
          {lr2c0, lr2c1, lr2c2, lr2c3},
          {lr3c0, lr3c1, lr3c2, lr3c3}
        },
        {
          {rr0c0, rr0c1, rr0c2, rr0c3},
          {rr1c0, rr1c1, rr1c2, rr1c3},
          {rr2c0, rr2c1, rr2c2, rr2c3},
          {rr3c0, rr3c1, rr3c2, rr3c3}
        }
      ) do
    {
      {
        lr0c0 * rr0c0 + lr0c1 * rr1c0 + lr0c2 * rr2c0 + lr0c3 * rr3c0,
        lr0c0 * rr0c1 + lr0c1 * rr1c1 + lr0c2 * rr2c1 + lr0c3 * rr3c1,
        lr0c0 * rr0c2 + lr0c1 * rr1c2 + lr0c2 * rr2c2 + lr0c3 * rr3c2,
        lr0c0 * rr0c3 + lr0c1 * rr1c3 + lr0c2 * rr2c3 + lr0c3 * rr3c3
      },
      {
        lr1c0 * rr0c0 + lr1c1 * rr1c0 + lr1c2 * rr2c0 + lr1c3 * rr3c0,
        lr1c0 * rr0c1 + lr1c1 * rr1c1 + lr1c2 * rr2c1 + lr1c3 * rr3c1,
        lr1c0 * rr0c2 + lr1c1 * rr1c2 + lr1c2 * rr2c2 + lr1c3 * rr3c2,
        lr1c0 * rr0c3 + lr1c1 * rr1c3 + lr1c2 * rr2c3 + lr1c3 * rr3c3
      },
      {
        lr2c0 * rr0c0 + lr2c1 * rr1c0 + lr2c2 * rr2c0 + lr2c3 * rr3c0,
        lr2c0 * rr0c1 + lr2c1 * rr1c1 + lr2c2 * rr2c1 + lr2c3 * rr3c1,
        lr2c0 * rr0c2 + lr2c1 * rr1c2 + lr2c2 * rr2c2 + lr2c3 * rr3c2,
        lr2c0 * rr0c3 + lr2c1 * rr1c3 + lr2c2 * rr2c3 + lr2c3 * rr3c3
      },
      {
        lr3c0 * rr0c0 + lr3c1 * rr1c0 + lr3c2 * rr2c0 + lr3c3 * rr3c0,
        lr3c0 * rr0c1 + lr3c1 * rr1c1 + lr3c2 * rr2c1 + lr3c3 * rr3c1,
        lr3c0 * rr0c2 + lr3c1 * rr1c2 + lr3c2 * rr2c2 + lr3c3 * rr3c2,
        lr3c0 * rr0c3 + lr3c1 * rr1c3 + lr3c2 * rr2c3 + lr3c3 * rr3c3
      }
    }
  end

  def multiply(
        {
          {lr0c0, lr0c1, lr0c2, lr0c3},
          {lr1c0, lr1c1, lr1c2, lr1c3},
          {lr2c0, lr2c1, lr2c2, lr2c3},
          {lr3c0, lr3c1, lr3c2, lr3c3}
        },
        {rr0, rr1, rr2, rr3}
      )
      when is_number(rr0) do
    {
      lr0c0 * rr0 + lr0c1 * rr1 + lr0c2 * rr2 + lr0c3 * rr3,
      lr1c0 * rr0 + lr1c1 * rr1 + lr1c2 * rr2 + lr1c3 * rr3,
      lr2c0 * rr0 + lr2c1 * rr1 + lr2c2 * rr2 + lr2c3 * rr3,
      lr3c0 * rr0 + lr3c1 * rr1 + lr3c2 * rr2 + lr3c3 * rr3
    }
  end

  def multiply(
        {lr0, _lr1, _lr2, _lr3} = left,
        {
          {_rr0c0, _rr0c1, _rr0c2, _rr0c3},
          {_rr1c0, _rr1c1, _rr1c2, _rr1c3},
          {_rr2c0, _rr2c1, _rr2c2, _rr2c3},
          {_rr3c0, _rr3c1, _rr3c2, _rr3c3}
        } = right
      )
      when is_number(lr0) do
    multiply(right, left)
  end

  def multiply({r, g, b}, n) when is_number(n), do: {r * n, g * n, b * n}

  def multiply(n, {_r, _g, _b} = color) when is_number(n) do
    multiply(color, n)
  end

  def multiply({x, y, z, 0}, n) when is_number(n), do: {x * n, y * n, z * n, 0}

  def multiply(n, {_x, _y, _z, 0} = vector) when is_number(n) do
    multiply(vector, n)
  end

  def multiply({lr, lg, lb}, {rr, rg, rb}), do: {lr * rr, lg * rg, lb * rb}

  def negate({x, y, z, 0}), do: {-x, -y, -z, 0}

  def normalize({x, y, z, 0} = vector) do
    m = magnitude(vector)
    {x / m, y / m, z / m, 0}
  end

  def submatrix(
        {
          {_r0c0, _r0c1, _r0c2} = r0,
          {_r1c0, _r1c1, _r1c2} = r1,
          {_r2c0, _r2c1, _r2c2} = r2
        },
        {row, column}
      )
      when row in [0, 1, 2] and column in [0, 1, 2] do
    Tuple.delete_at(
      {
        Tuple.delete_at(r0, column),
        Tuple.delete_at(r1, column),
        Tuple.delete_at(r2, column)
      },
      row
    )
  end

  def submatrix(
        {
          {_r0c0, _r0c1, _r0c2, _r0c3} = r0,
          {_r1c0, _r1c1, _r1c2, _r1c3} = r1,
          {_r2c0, _r2c1, _r2c2, _r2c3} = r2,
          {_r3c0, _r3c1, _r3c2, _r3c3} = r3
        },
        {row, column}
      )
      when row in [0, 1, 2, 3] and column in [0, 1, 2, 3] do
    Tuple.delete_at(
      {
        Tuple.delete_at(r0, column),
        Tuple.delete_at(r1, column),
        Tuple.delete_at(r2, column),
        Tuple.delete_at(r3, column)
      },
      row
    )
  end

  def subtract({lr, lg, lb}, {rr, rg, rb}), do: {lr - rr, lg - rg, lb - rb}

  def subtract({lx, ly, lz, lw}, {rx, ry, rz, rw})
      when lw in [0, 1] and rw in [0, 1] and lw + rw != -1 do
    {lx - rx, ly - ry, lz - rz, lw - rw}
  end

  def transpose({
        {r0c0, r0c1, r0c2, r0c3},
        {r1c0, r1c1, r1c2, r1c3},
        {r2c0, r2c1, r2c2, r2c3},
        {r3c0, r3c1, r3c2, r3c3}
      }) do
    {
      {r0c0, r1c0, r2c0, r3c0},
      {r0c1, r1c1, r2c1, r3c1},
      {r0c2, r1c2, r2c2, r3c2},
      {r0c3, r1c3, r2c3, r3c3}
    }
  end
end
